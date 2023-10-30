terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">= 2.0"
  }
}



resource "azurerm_storage_account" "storage" {
  name                = var.name
  resource_group_name = var.storage_rsg
  location            = var.location

  account_kind             = var.account_kind
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  access_tier              = var.access_tier
  is_hns_enabled           = var.data_lake

  tags = merge({
    Environment = var.environment
    BuildBy     = var.tag_buildby
    BuildTicket = var.tag_buildticket
    BuildDate   = var.tag_builddate
  }, var.global_tags)
}

