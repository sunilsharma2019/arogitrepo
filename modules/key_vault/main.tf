locals {
  admin_permissions = {
       certificates = [
         "Create",
         "Delete",
         "DeleteIssuers",
         "Get",
         "GetIssuers",
         "Import",
         "List",
         "ListIssuers",
         "ManageContacts",
         "ManageIssuers",
         "Recover",
         "SetIssuers",
         "Update",
         "Backup",
         "Restore"
        ]

    keys = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey",
    ]

    secrets = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Set",
    ]
  }

  readonly_permissions = [
    "Get",
    "List",
  ]
}

data "azurerm_client_config" "current" {
}

resource "azurerm_key_vault" "kv" {
  name                = var.keyvault.name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = var.keyvault.sku

  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true

#   # 1. Allow the current Service Principal (i.e. whoever is running Terraform) access to read/create secrets
#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = var.service_connection_id

#     key_permissions = [
#       "Get",
#       "List",
#       "Create",
#     ]

#     secret_permissions = [
#       "Get",
#       "List",
#       "Set",
#     ]

#     certificate_permissions = [
#       "Create",
#       "Delete",
#       "Get",
#       "List",
#     ]
#   }
#   network_acls {
#     default_action = "Allow"
#     bypass         = "AzureServices"
#   }
  
# 3. Create Access Policies for every Object ID specified through the *.tfvars file
  dynamic "access_policy" {
    for_each = var.keyvault_access

    content {
      tenant_id = data.azurerm_client_config.current.tenant_id
      object_id = access_policy.value.ad_object_id

      certificate_permissions = access_policy.value.has_admin_access ? local.admin_permissions.certificates : local.readonly_permissions
      key_permissions         = access_policy.value.has_admin_access ? local.admin_permissions.keys : local.readonly_permissions
      secret_permissions      = access_policy.value.has_admin_access ? local.admin_permissions.secrets : local.readonly_permissions
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
  
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  count                      = length(var.loganalytics_id)
  name                       = format("diag%s", count.index)
  target_resource_id             = azurerm_key_vault.kv.id
  log_analytics_workspace_id     = var.loganalytics_id[count.index]

  log {
    category_group = "allLogs"
    enabled        = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category_group = "audit"
    enabled        = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}