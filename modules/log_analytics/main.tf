resource "azurerm_log_analytics_workspace" "lgw" {
  name                = var.loganalytics_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.loganalytics_settings.sku
  retention_in_days   = var.loganalytics_settings.retention_days
  tags                = var.tags
}