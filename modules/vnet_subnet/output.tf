output "vnet_subnets" {
  value = [
    for subnet in var.subnets :
    {
      "name" = azurerm_subnet.subnet[index(var.subnets, subnet)].name
      "id"   = azurerm_subnet.subnet[index(var.subnets, subnet)].id
    }
  ]
}