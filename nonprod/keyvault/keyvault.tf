module "keyvault" {
  source = "../../modules/keyvault"
  resource_group = {
    name     = var.rg1.name
    location = var.rg1.location
  }

  keyvault        = var.keyvault
  keyvault_access = var.keyvault_access
  tags            = var.global_tags
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.oms.id
}