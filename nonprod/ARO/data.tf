data "azurerm_key_vault_secret" "pull-secret" {
  name         = "pull-secret"
  key_vault_id = "/subscriptions/37f26f9f-6c7c-4be6-9442-56e71b2d14e2/resourceGroups/rg-eandmoney-NonProd-01/providers/Microsoft.KeyVault/vaults/kvlt-eandmoney-nonprd-01"
}

data "azurerm_subscription" "current" {}

output "subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "tenant_id" {
  value = data.azurerm_subscription.current.tenant_id
}

data "azuread_client_config" "current" {}

# data "azurerm_virtual_network" "peeredvnet" {
#   name                = "eandmoney-nonpro-vnet"
#   resource_group_name = "emoney-netrg"
# }

# output "peeredvnet_id" {
#   value = data.azurerm_virtual_network.peeredvnet.id
# }

data "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-eandmoney-nonprod-01"
  resource_group_name = "rg-eandmoney-NonProd-01"
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.virtual_network.id
}

# data "azurerm_log_analytics_workspace" "oms" {
#   name                = "oms-eandmoney-nonprod-01"
#   resource_group_name = "rg-eandmoney-nonprod-01"
# }

# output "log_analytics_workspace_id" {
#   value = data.azurerm_log_analytics_workspace.oms.workspace_id
# }

data "azurerm_subnet" "master_subnet" {
  name                 = "ARO-MASTERS-SN"
  virtual_network_name = "vnet-eandmoney-nonprod-01"
  resource_group_name  = "rg-eandmoney-NonProd-01"
}

output "master_subnet_id" {
  value = data.azurerm_subnet.master_subnet.id
}

data "azurerm_subnet" "worker_subnet" {
  name                 = "ARO-WORKERS-SN"
  virtual_network_name = "vnet-eandmoney-nonprod-01"
  resource_group_name  = "rg-eandmoney-NonProd-01"
}

output "worker_subnet_id" {
  value = data.azurerm_subnet.worker_subnet.id
}

data "azurerm_resource_group" "rsg" {
  name = "rg-eandmoney-NonProd-01"
}