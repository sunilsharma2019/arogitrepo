resource "azurerm_subnet" "subnet" {
  count                                          = length (var.subnets)
  resource_group_name                            = var.resource_group.name
  name                                           = var.subnets[count.index].name
  address_prefixes                               = var.subnets[count.index].subnet_prefix
  virtual_network_name                           = var.vnet_name
  private_endpoint_network_policies_enabled = var.subnets[count.index].endpoint_network_policies
  private_link_service_network_policies_enabled = var.subnets[count.index].service_network_policies


   dynamic "delegation" {
        for_each = var.subnets[count.index].service_delegation ? [1] : []
        
        content {
            name = "delegation"

            service_delegation {
              name    = var.subnets[count.index].service_delegation_name
              actions = var.subnets[count.index].service_delegation_action
            }
        }
    }
}