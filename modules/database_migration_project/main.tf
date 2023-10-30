resource "azurerm_database_migration_service" "datascope" {
  name                = var.service_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  subnet_id           = var.subnet_id
  sku_name            = var.sku_name
  tags = var.tags

  

}

resource "azurerm_database_migration_project" "datascope" {
  count               = length(var.projects)
  name                = var.projects[count.index].name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  service_name        = azurerm_database_migration_service.datascope.name
  source_platform     = var.projects[count.index].source_platform
  target_platform     = var.projects[count.index].target_platform

  # Add additional configuration options here as needed
  depends_on = [azurerm_database_migration_service.datascope]
}
