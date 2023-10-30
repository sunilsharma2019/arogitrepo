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
  sku {
    name     = var.sku_name
    tier     = var.sku_tier
    capacity = var.sku_capacity
  }

  waf_configuration {
    enabled          = var.waf_configuration_enabled
    firewall_mode    = var.firewall_mode
    rule_set_version = var.waf_rule_set_version
  }

  autoscale_configuration {
    min_capacity = var.app_gateway_min_capacity
    max_capacity = var.app_gateway_max_capacity
  }

  identity {
    identity_ids = var.identity_ids
    type         = var.identity_type
  }

    dynamic "frontend_port" {
      for_each = var.frontend_ports
      content {
        name = frontend_port.value.name
        port = frontend_port.value.port
      }
    }

    dynamic "frontend_ip_configuration" {
      for_each = var.frontend_ip_configurations
      content {
        name                 = frontend_ip_configuration.value.name
        public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
      }
    }

    dynamic "ssl_certificate" {
      for_each = var.ssl_certificates
      content {
        name     = ssl_certificate.value.name
        key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
#        data     = ssl_certificate.value.data
#        password = ssl_certificate.value.password
      }
    }

    dynamic "http_listener" {
      for_each = var.http_listeners
      content {
        name                           = http_listener.value.name
        frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
        frontend_port_name             = http_listener.value.frontend_port_name
        protocol                       = http_listener.value.protocol
        host_name                      = http_listener.value.host_name
        host_names                     = http_listener.value.host_names
        ssl_certificate_name           = http_listener.value.ssl_certificate_name
        require_sni                    = http_listener.value.require_sni
      }
    }

    dynamic "backend_address_pool" {
      for_each = var.backend_address_pools
      content {
        name = backend_address_pool.value.name
        fqdns = backend_address_pool.value.fqdns
        ip_addresses = backend_address_pool.value.ip_addresses
      }
    }

    dynamic "backend_http_settings" {
      for_each = var.backend_http_settings
      content {
        name                  = backend_http_settings.value.name
        cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
        pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
        probe_name            = backend_http_settings.value.probe_name
        protocol              = backend_http_settings.value.protocol
        request_timeout       = backend_http_settings.value.request_timeout
        port                  = backend_http_settings.value.port
        affinity_cookie_name  = backend_http_settings.value.affinity_cookie_name
      }
    }

    dynamic "request_routing_rule" {
      for_each = var.request_routing_rules
      content {
        name                       = request_routing_rule.value.name
        rule_type                  = request_routing_rule.value.rule_type
        http_listener_name         = request_routing_rule.value.http_listener_name
        priority                   = request_routing_rule.value.priority
        backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
        backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
        url_path_map_name          = request_routing_rule.value.url_path_map_name
      }
    }
/*
    dynamic "redirect_configuration" {
      for_each = var.redirect_configuration
      content {
          name                  = redirect_configuration.value.name
          redirect_type         = redirect_configuration.value.redirect_type
          target_listener_name  = redirect_configuration.value.target_listener_name
          target_url            = redirect_configuration.value.target_url
          include_path          = redirect_configuration.value.include_path
          include_query_string  = redirect_configuration.value.include_query_string
        }
    }
*/
    dynamic "url_path_map" {
      for_each = var.url_path_maps
      content {
        name = url_path_map.value.name
        default_backend_address_pool_name    = url_path_map.value.default_backend_address_pool_name
        default_backend_http_settings_name   = url_path_map.value.default_backend_http_settings_name
        path_rule {
          name     = url_path_map.value.path_rule.name
          paths     = url_path_map.value.path_rule.paths
          backend_address_pool_name      = url_path_map.value.path_rule.backend_address_pool_name
          backend_http_settings_name     = url_path_map.value.path_rule.backend_http_settings_name
          
        }

      }
    }

    dynamic "probe" {
  for_each = var.probes
  content {
    name                      = probe.value.name
    protocol                  = probe.value.protocol
#    host                      = probe.value.host
    path                      = probe.value.path
    interval                  = probe.value.interval
    timeout                   = probe.value.timeout
    unhealthy_threshold       = probe.value.unhealthy_threshold
    pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings

    dynamic "match" {
      for_each = probe.value.match
      content {
        status_code = probe.value.match.status_code
      }
    }
  }
}


    dynamic "gateway_ip_configuration" {
      for_each = var.gateway_ip_configurations
      content {
        name      = gateway_ip_configuration.value.name
        subnet_id = gateway_ip_configuration.value.subnet_id
      }
    }
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
