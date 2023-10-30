output "lgw" {
  value     = azurerm_log_analytics_workspace.lgw
  sensitive = true
}

output "lgw_id" {
  value     = azurerm_log_analytics_workspace.lgw.id
}