resource "azurerm_automation_account" "automation_runbook" {
  location            = var.azurelocation
  name                = var.azureautomationaccountname
  resource_group_name = var.resource_group_name
  sku_name            = "Basic"
}
