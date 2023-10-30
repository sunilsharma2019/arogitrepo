module "nsg_PUBLIC" {
  source = "git@github.com:global-azure/terraform-azurerm-nsg.git"

  nsg_name = "EA-VNET01-PRD-WEB-NSG"
  nsg_rsg  = "FC-EA-RSG-MGT-PRD"
  location = var.location

  subnet_id_association     = "/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-MGT-PRD/providers/Microsoft.Network/virtualNetworks/FC-EA-VNET01-PRD/subnets/EA-VNET01-SUBNET-WEB"
  subnet_range              = "192.168.4.0/24"
  add_default_rules         = true
  add_agw_v1_rules          = false
  add_agw_v2_rules          = false
  add_ad_rules              = false
  add_altm_rules            = false
  add_deny_rules            = true
  additional_allow_rules    = var.additional_allow_rules_PUBLIC

  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = replace(substr(timestamp(), 0, 10), "-", "")

  depends_on = [
    module.vnet1
  ]
}

variable "additional_allow_rules_PUBLIC" {
  description = "List of additional NSG rules to create."
  default = {
    301 = {
      name                    = "Allow_P2SVPN_Inbound"
      priority                = 301
      protocol                = "Tcp"
      destination_port_ranges = ["22","80","443","3306"]
      source_address_prefix   = "192.168.200.0/24"
      source_address_prefixes = null
    }
  }
}
