resource "azurerm_key_vault_secret" "key-vault-secret" {
  key_vault_id = var.key_vault_id
  for_each     = var.key_vault_secrets
  name         = each.key
  value        = each.value
}

output "all" {
  value = azurerm_key_vault_secret.key-vault-secret
}