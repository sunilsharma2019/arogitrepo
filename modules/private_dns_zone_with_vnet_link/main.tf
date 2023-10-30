# Define the Private DNS Zone
resource "azurerm_private_dns_zone" "my_dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group.name
}

# Link the Private DNS Zone with the virtual networks
resource "azurerm_private_dns_zone_virtual_network_link" "vnet1_link" {
  count                 = length(var.vnet_link)
  name                  = var.vnet_link[count.index].name
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.my_dns_zone.name
  virtual_network_id    = var.vnet_link[count.index].ids
}