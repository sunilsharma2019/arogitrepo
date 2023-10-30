###################################################

###################################################
# Create customer required storage account
#
module "storage" {
  source            = "../../modules/storage_account"

  name             = "stgeandmoneystdlrsnprd01"
  storage_rsg      = var.storage_rsg.name
  # account_kind     = "StorageV2"
  # account_tier     = "Standard"
  # replication_type = "LRS"
  # access_tier      = "Hot"
  # data_lake        = false

  location        = var.storage_rsg.location
  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = var.builddate
  global_tags     = var.global_tags
}
