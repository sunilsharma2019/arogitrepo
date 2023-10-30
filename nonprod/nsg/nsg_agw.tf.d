#######################################################
#  NSGs definition, they are placed in separated file than network.tf to allow base networks to be setup first.
#
#  Use this command to find subnet ID (for subnet_id_association below):
#    az network vnet subnet list -g FC-EA-RSG-MGT-PRD --vnet-name FC-EA-VNET01-PRD --query "[].{Name:name,SubnetID:id}"
#

# Output results:
#[
#  {
#    "Name": "GatewaySubnet",
#    "SubnetID": "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/GatewaySubnet"
#  },
#  {
#    "Name": "EA-VNET01-SUBNET-AGW",
#    "SubnetID": "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-SUBNET-AGW"
#  },
#  {
#    "Name": "EA-VNET01-PRD-WEB",
#    "SubnetID": "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-PRD-WEB"
#  },
#  {
#    "Name": "EA-VNET01-SUBNET-APP",
#    "SubnetID": "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-SUBNET-APP"
#  },
#  {
#    "Name": "EA-VNET01-SUBNET-RBAST01",
#    "SubnetID": "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-SUBNET-RBAST01"
#  }
#]
 
module "nsg_AGW" {
  source = "git@github.com:global-azure/terraform-azurerm-nsg.git"
  
  nsg_name = "EA-VNET01-PRD-AGW-NSG"
  nsg_rsg  = "FC-EA-RSG-MGT-PRD"
  location = var.location

  subnet_id_association     = "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-SUBNET-AGW"
  subnet_range              = "192.168.1.0/24"
  add_default_rules         = true
  add_agw_v1_rules          = false
  add_agw_v2_rules          = true
  add_ad_rules              = false
  add_altm_rules            = false
  add_deny_rules            = true
  additional_allow_rules    = var.additional_allow_rules_AGW

  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = replace(substr(timestamp(), 0, 10), "-", "")

  depends_on = [
    module.vnet1
  ]
}


variable "additional_allow_rules_AGW" {
  description = "List of additional NSG rules to create."
  default = {
    300 = {
      name                    = "Allow_HTTP_INBOUND"
      priority                = 200
      protocol                = "Tcp"
      destination_port_ranges = ["80"]
      source_address_prefix   = null
      source_address_prefixes = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
    }
    310 = {
      name                    = "Allow_HTTPS_INBOUND"
      priority                = 310
      protocol                = "Tcp"
      destination_port_ranges = ["443"]
      source_address_prefix   = null
      source_address_prefixes = ["173.245.48.0/20","103.21.244.0/22","103.22.200.0/22","103.31.4.0/22","141.101.64.0/18","108.162.192.0/18","190.93.240.0/20","188.114.96.0/20","197.234.240.0/22","198.41.128.0/17","162.158.0.0/15","104.16.0.0/12","172.64.0.0/13","131.0.72.0/22"]
    }
  }
}