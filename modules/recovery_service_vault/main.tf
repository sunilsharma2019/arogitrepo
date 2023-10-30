resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_vault_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = "Standard"

  soft_delete_enabled = var.soft_delete_enabled
  tags                = var.tags
}

resource "azurerm_backup_policy_vm" "backup_policy" {
  name                = var.backup_policy_name
  resource_group_name = var.resource_group.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  timezone = "W. Europe Standard Time"
  backup {
    frequency = "Daily"
    time      = "23:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Sunday"]
  }

}
