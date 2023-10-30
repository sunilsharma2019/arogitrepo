resource "azurerm_key_vault_secret" "pull-secret" {
  name         = var.secret_name
  value        = file(var.pull_secret_file)
  key_vault_id = module.keyvault.keyvault.id
}
