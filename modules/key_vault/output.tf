output "keyvault" {
  value = azurerm_key_vault.kv
}

output "id" {
  value = azurerm_key_vault.kv.id
}
output "keyvault_url" {
  value = "https://${var.keyvault.name}.vault.azure.net/"
}