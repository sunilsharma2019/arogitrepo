locals {
  backend_address_pool_name              = "${var.appgwconfig}-beap"
#  frontend_port_name_https               = "${var.appgwconfig}-https"
  frontend_port_name_http                = "${var.appgwconfig}-http"
  frontend_ip_configuration_name         = "${var.appgwconfig}-feip"
#   frontend_private_ip_configuration_name = "${var.appgwconfig}-feiprivate"
  http_setting_name                      = "${var.appgwconfig}-be-htst"
  listener_name                          = "${var.appgwconfig}-httplstn"
 httpslistener_name                      = "${var.appgwconfig}-httpslstn"
  request_routing_rule_name              = "${var.appgwconfig}-rqrt"
}

resource "azurerm_public_ip" "appgw" {
  name                = var.appgw_public_ip
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "network" {
  name                = var.app_gateway_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  enable_http2        = var.enable_http2
#  firewall_policy_id  = azurerm_web_application_firewall_policy.waf_policy.id

  sku {
    name = var.app_gateway_sku
    tier = var.app_gateway_sku
  }

   autoscale_configuration {
    min_capacity = var.app_gateway_min_capacity
    max_capacity = var.app_gateway_max_capacity
  }

  waf_configuration {
    enabled          = true
    firewall_mode    = var.firewall_mode
    rule_set_version = "3.2"
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = var.appgw_subnet_id
  }

  frontend_port {
    name = local.frontend_port_name_http
    port = 80
  }

  frontend_port {
    name = "httpsPort"
    port = 443
  }
#   ssl_policy {
#     policy_type = "Predefined"
#     policy_name = "AppGwSslPolicy20170401S"
#   }


  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

#   frontend_ip_configuration {
#     name                          = local.frontend_private_ip_configuration_name
#     private_ip_address            = var.appgw_private_ip
#     private_ip_address_allocation = "Static"
#     subnet_id                     = var.appgw_subnet_id
#   }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = var.cookie_based_affinity
    port                  = var.port
    protocol              = var.protocol
    request_timeout       = var.request_timeout
  }

  http_listener {
    name                           = var.http_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name_http
    protocol                       = var.protocol
    #ssl_certificate_id             = var.ssl_certificate_id
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
    priority                   = 10
  }




#   ssl_certificate {
#     name                = "edge-dev-ssl-cert"
# #    key_vault_secret_id = "https://${var.keyvault_name}.vault.azure.net/secrets/${var.appgw_ssl_certificate_name}/"
#     key_vault_secret_id = azurerm_key_vault_certificate.cluster_agw.secret_id
#   }

#   rewrite_rule_set {
#     name = var.rewrite_rule_name
#     rewrite_rule {
#       name          = "NewRewrite"
#       rule_sequence = 100

#       request_header_configuration {
#         header_name  = "X-Forwarded-For"
#         header_value = "{var_client_ip}"
#       }
#     }
#   }

  lifecycle {
    ignore_changes = [
      request_routing_rule,
      url_path_map,
      backend_http_settings,
      backend_address_pool,
      http_listener,
      frontend_port,
      probe,
      redirect_configuration,
      tags,
      ssl_certificate,
      identity,
      # firewall_policy_id
      # rewrite_rule_set
    ]
  }


  depends_on = [azurerm_public_ip.appgw]
}

resource "azurerm_monitor_diagnostic_setting" "appgw" {
  count                      = length(var.loganalytics_id)
  name                       = format("diag%s", count.index)
  target_resource_id             = azurerm_application_gateway.network.id
  log_analytics_workspace_id     = var.loganalytics_id[count.index]

  log {
    category_group = "allLogs"
    enabled        = true
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

resource "azurerm_monitor_diagnostic_setting" "appgw_ip_diag" {
  count                      = length(var.loganalytics_id)
  name                       = format("diag%s", count.index)
  target_resource_id         = azurerm_public_ip.appgw.id
  log_analytics_workspace_id = var.loganalytics_id[count.index]

  log {
    category = "DDoSProtectionNotifications"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "DDoSMitigationFlowLogs"
    retention_policy {
      enabled = false
    }
  }
  log {
    category = "DDoSMitigationReports"
    retention_policy {
      enabled = false
    }
  }
  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}

resource "azurerm_web_application_firewall_policy" "waf_policy" {
  name                = upper("${var.app_gateway_name}-POLICY")
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  policy_settings {
    enabled                     = true
    mode                        = "${var.mode}"
    request_body_check          = true
    file_upload_limit_in_mb     = 100
    max_request_body_size_in_kb = 128
  }

  managed_rules {

    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }

  dynamic "custom_rules" {
    for_each = var.custom_rules
    content {
      # Required
      name      = lookup(custom_rules.value, "name")
      action    = lookup(custom_rules.value, "action")
      rule_type = lookup(custom_rules.value, "type")
      priority  = lookup(custom_rules.value, "priority", null)

      dynamic "match_conditions" {
        # for_each = var.waf_custom_rule_match_conditions
        for_each = lookup(custom_rules.value, "match_conditions")
        content {
          # Required
          dynamic "match_variables" {
            for_each = lookup(match_conditions.value, "match_variables")
            content {
              variable_name = lookup(match_variables.value, "variable_name")
            }
          }
          match_values = lookup(match_conditions.value, "match_values")
          operator     = lookup(match_conditions.value, "operator")
          # Optional
          negation_condition = lookup(match_conditions.value, "negation_condition", null)
          transforms         = lookup(match_conditions.value, "transforms", null)

        }
      }

    }
  }
  lifecycle {
    ignore_changes = [
      name,
      location,
      http_listener_ids,
      path_based_rule_ids
    ]
  }
}