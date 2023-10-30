# Module to create an Azure NSG with flow logs and storage account
# Usage: 
# module "nsg-flowlogs" {
#   source                = "./modules/nsg-flowlogs"
#   resource_group_name   = "example-rg"
#   storage_account_name  = "examplelogs"
#   storage_account_rg    = "examplelogs-rg"
# }

resource "azurerm_storage_account" "logs_storage" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_network_watcher" "network_watcher" {
  name                     = var.network_watcher_name
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
}

resource "azurerm_storage_container" "logs_container" {
  name                  = var.flow_logs_container_name
  storage_account_name  = azurerm_storage_account.logs_storage.name
  container_access_type = "private"
}

resource "azurerm_network_watcher_flow_log" "flow_logs" {
  network_watcher_name          = azurerm_network_watcher.network_watcher.name
  resource_group_name           = var.resource_group.name
  name                          = var.flow_log_name
  network_security_group_id     = var.nsg_id
  storage_account_id            = azurerm_storage_account.logs_storage.id
  enabled                        = true
  retention_policy {
    enabled = true
    days    = 90
  }
}
