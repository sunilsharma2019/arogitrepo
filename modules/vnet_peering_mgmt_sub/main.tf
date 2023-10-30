resource "azurerm_virtual_network_peering" "peering" {
  count                        = length(var.peering)
  name                         = var.peering[count.index].name
  resource_group_name          = var.resource_group.name
  virtual_network_name         = var.peering_vnet_name
  remote_virtual_network_id    = var.peering[count.index].remote_vnet_name
  use_remote_gateways          = var.peering[count.index].use_remote_gateways
  allow_gateway_transit        = var.peering[count.index].allow_gateway_transit
  allow_forwarded_traffic      = var.peering[count.index].allow_forwarded_traffic
  provider                     = azurerm.mgmt_sub
}