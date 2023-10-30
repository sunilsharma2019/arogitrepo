resource "azurerm_virtual_network_gateway_connection" "gw_connection" {
  count                           = length(var.connection_name)
  name                            = var.connection_name[count.index]
  location                        = var.resource_group.location
  resource_group_name             = var.resource_group.name

  type                            = var.type[count.index]
  virtual_network_gateway_id      = var.virtual_network_gateway_id[count.index]
  local_network_gateway_id        = var.local_network_gateway_id[count.index]
#  peer_virtual_network_gateway_id = var.peer_virtual_network_gateway_id[count.index]

##  traffic_selector_policy {
##    local_address_cidrs      =  var.local_address_cidrs[count.index].address_space
##    remote_address_cidrs     =  var.remote_address_cidrs[count.index].address_space
##  }

  shared_key                 = var.shared_key[count.index]
}
