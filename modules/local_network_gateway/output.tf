output "local_gateway_id" {
  value = azurerm_local_network_gateway.local_gateway[0].id
#  value = [
#    for subnet in var.local_gateway_name :
#    { 
#      "id"   = azurerm_local_network_gateway.local_gateway[index(var.local_gateway_name,[*])].id
#    }
#  ]
}
