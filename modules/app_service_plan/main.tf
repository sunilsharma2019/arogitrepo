resource "azurerm_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  os_type             = "Windows"
  sku_name            = var.app_service_sku_name
}