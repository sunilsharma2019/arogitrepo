terraform {
  required_version = ">= 0.12"
  required_providers {
    azurerm = ">= 2.0"
  }
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_rsg
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_user


  dynamic "georeplications" {
    for_each = var.acr_sku == "Premium" ? var.georeplications : []

    content {
      location                = georeplications.value["location"]
      zone_redundancy_enabled = georeplications.value["zone_redundancy_enabled"]
    }
  }

  dynamic "network_rule_set" {
    for_each = var.acr_sku == "Premium" && (length(var.network_rules_subnet) > 0 || length(var.network_rules_ip) > 0) ? [1] : []

    content {
      default_action = var.network_rules_default_allow == true ? "Allow" : "Deny"

      dynamic "virtual_network" {
        for_each = toset(var.network_rules_subnet)
        content {
          subnet_id = virtual_network.key
          action    = "Allow"
        }
      }

      dynamic "ip_rule" {
        for_each = toset(var.network_rules_ip)
        content {
          ip_range = ip_rule.key
          action   = "Allow"
        }
      }
    }
  }


  tags = merge({
    Environment = var.environment
    BuildBy     = var.tag_buildby
    BuildTicket = var.tag_buildticket
    BuildDate   = var.tag_builddate
  }, var.tag_custom)
}

############ Enable Diagnostic Settings #######3
resource "azurerm_monitor_diagnostic_setting" "acrdiag" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

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