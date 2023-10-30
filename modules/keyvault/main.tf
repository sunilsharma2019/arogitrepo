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

############### Diagnostic Settings ##########3

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_key_vault.kv.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # "log_analytics_destination_type" is unconfigurable for Key Vault.
  # Ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.65.0/docs/resources/monitor_diagnostic_setting#log_analytics_destination_type
  log_analytics_destination_type = null

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

  }
}