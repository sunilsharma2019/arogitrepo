module "oms" {
  source            = "../../modules/log_analytics"
  loganalytics_name = var.loganalytics_name
  resource_group = {
    name     = var.rg1.name
    location = var.rg1.location
  }
  loganalytics_settings = var.loganalytics_settings
  tags                  = var.global_tags
}