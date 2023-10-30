resource "azurerm_local_network_gateway" "local_gateway" {
  count               = length(var.local_gateway_name)
  name                = var.local_gateway_name[count.index]
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  gateway_address     = var.gateway_address[count.index]
  address_space       = var.gateway[count.index].address_space
}