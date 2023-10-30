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
  name                            = var.keyvault.name
  resource_group_name             = var.resource_group.name
  location                        = var.resource_group.location

  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.keyvault.sku
  public_network_access_enabled   = var.public_network_access_enabled
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  purge_protection_enabled        = true
  
# Create Access Policies for every Object ID specified through the *.tfvars file
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

# Create a private endpoint for the Key Vault
resource "azurerm_private_endpoint" "kv_pep" {
  name                = var.kv_pep_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  subnet_id = var.kv_subnet_id

  # Configure the private DNS zone and the Key Vault resource
  private_service_connection {
    name                           = var.kv_pep_connection_name
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

    private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [var.kv_pep_dns_zone_id]
  }
}
