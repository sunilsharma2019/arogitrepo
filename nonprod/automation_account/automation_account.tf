#######################################################
# Create customer required automation accounts 
#
module automation {
source = "github.com/global-azure/terraform-azurerm-automation.git"
  rsg             = data.azurerm_resource_group.netrg.name
  coreDevice      = "1234567"
  location        = var.location
  environment     = var.environment
  tag_buildby     = var.buildby
  tag_buildticket = var.buildticket
  tag_builddate   = replace(substr(timestamp(), 0, 10), "-", "")
}