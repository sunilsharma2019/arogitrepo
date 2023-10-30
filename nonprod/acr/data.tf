data "azurerm_resource_group" "rsg" {
  name = "rg-eandmoney-NonProd-01"
}

data "azurerm_log_analytics_workspace" "oms" {
  name                = "oms-eandmoney-nonprod-01"
  resource_group_name = "rg-eandmoney-nonprod-01"
}

data "azurerm_virtual_network" "virtual_network" {
  name = "vnet-eandmoney-nonprod-01"
  resource_group_name = data.azurerm_resource_group.rsg.name
}

data "azurerm_subnet" "mastersubnet" {
  name = "ARO-MASTERS-SN"
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  resource_group_name = data.azurerm_resource_group.rsg.name
}

data "azurerm_subnet" "workersubnet" {
  name = "ARO-WORKERS-SN"
  virtual_network_name = data.azurerm_virtual_network.virtual_network.name
  resource_group_name = data.azurerm_resource_group.rsg.name
}