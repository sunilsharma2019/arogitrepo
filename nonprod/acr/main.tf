module "acr" {
  source               = "../../modules/acr"
  acr_name             = var.registry_name
  location             = var.location
  acr_rsg              = data.azurerm_resource_group.rsg.name
  acr_sku              = var.sku
  acr_admin_user       = var.admin_enabled
  georeplications      = var.georeplications
  network_rules_subnet = [data.azurerm_subnet.mastersubnet.id, data.azurerm_subnet.workersubnet.id]
  network_rules_ip     = var.network_rules_ip

  environment                               = var.environment
  tag_buildby                               = var.tag_buildby
  tag_buildticket                           = var.tag_buildby
  tag_builddate                             = var.tag_builddate
  tag_custom                                = var.global_tags
  diagnostic_setting_enabled_log_categories = var.diagnostic_setting_enabled_log_categories
  diagnostic_setting_name                   = var.diagnostic_setting_name
  log_analytics_workspace_id                = data.azurerm_log_analytics_workspace.oms.id
}