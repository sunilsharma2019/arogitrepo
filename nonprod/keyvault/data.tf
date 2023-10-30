data "azurerm_log_analytics_workspace" "oms" {
  name                = "oms-eandmoney-nonprod-01"
  resource_group_name = "rg-eandmoney-nonprod-01"
}