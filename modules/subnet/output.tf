output "sub2_id" {
  value = azurerm_subnet.subnet[1].id
}

output "sub1_id" {
  value = azurerm_subnet.subnet[0].id
}

# output "sub3_id" {
#   value = azurerm_subnet.subnet[2].id
# }

# output "sub4_id" {
#   value = azurerm_subnet.subnet[3].id
# }