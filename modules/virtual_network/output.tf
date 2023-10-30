output "vnet" {
  value = azurerm_virtual_network.vnet
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "out_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}