resource "azurerm_application_insights" "app_insight" {
  name                = var.app_insight_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  application_type    = "web"
}

resource "azurerm_windows_web_app" "web_app" {
  name                = var.app_service_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  service_plan_id     = var.service_plan_id
  https_only          = true
  site_config {
    always_on           = true
    minimum_tls_version = "1.2"
    http2_enabled       = true

    # Define your dynamic virtual applications here (same as before)
    dynamic "virtual_application" {
      for_each = var.virtual_applications
      content {
        preload       = virtual_application.value.preload
        physical_path = virtual_application.value.physical_path
        virtual_path  = virtual_application.value.virtual_path

      }
    }

    # Define your dynamic IP Restriction here
    dynamic "ip_restriction" {
      for_each = var.ip_restrictions
      content {
        action     = ip_restriction.value.action
        headers    = []
        ip_address = ip_restriction.value.ip_address
        name       = ip_restriction.value.name
        priority   = ip_restriction.value.priority
      }
    }

    # Define your dynamic SCM IP Restriction here
    dynamic "scm_ip_restriction" {
      for_each = var.scm_ip_restrictions
      content {
        action     = scm_ip_restriction.value.action
        headers    = []
        ip_address = scm_ip_restriction.value.ip_address
        name       = scm_ip_restriction.value.name
        priority   = scm_ip_restriction.value.priority
      }
    }

    /*
    ip_restriction {
      action     = "Allow"
      headers    = []
      ip_address = "31.60.38.47/32"
      name       = "FromArturHome"
      priority   = 100
    }
    ip_restriction {
      action     = "Allow"
      headers    = []
      ip_address = "80.193.73.114/32"
      name       = "EMEA"
      priority   = 200
    }

    scm_ip_restriction {
      action     = "Allow"
      headers    = []
      ip_address = "31.60.38.47/32"
      name       = "FromArtur-Home"
      priority   = 100
    }
   */
  }

  virtual_network_subnet_id = var.app_subnet_id


  #app_settings = {
  #    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.app_insight.instrumentation_key
  #  }

  #  app_settings = {
  #    "WEBSITE_ENABLE_APP_SERVICE_STORAGE" = "false"
  #    "WEBSITE_VNET_ROUTE_ALL"            = "1"
  #    "WEBSITE_DNS_SERVER"                = "168.63.129.16"
  #    "APPINSIGHTS_INSTRUMENTATIONKEY"    = "<app-insights-instrumentation-key>"
  #  }

  app_settings = {
    "SystemName"                      = var.app_settings_SystemName
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE" = var.app_settings_WEBSITE_ENABLE_SYNC_UPDATE_SITE
    "serilog:write-to:Seq.serverUrl"  = var.app_settings_serilog
    "APPINSIGHTS_INSTRUMENTATIONKEY"  = azurerm_application_insights.app_insight.instrumentation_key
  }

  logs {
    detailed_error_messages = false
    failed_request_tracing  = false

    http_logs {
      file_system {
        retention_in_days = 3
        retention_in_mb   = 100
      }
    }
  }
  #  site_logs {
  #    application_logs {
  #      azure_blob_storage {
  #        level             = "Error"
  #        retention_in_days = 7
  #        sas_url           = "<blob-sas-url>"
  #      }
  #    }
  #  }

  #  log_analytics_workspace_id = var.lgw_id
  #  outbound_ip_addresses     = "None"
}

resource "azurerm_monitor_diagnostic_setting" "app_service_diag" {
  name               = "${var.app_service_diag_name}-diagnostic-setting"
  target_resource_id = azurerm_windows_web_app.web_app.id

  log_analytics_workspace_id = var.lgw_id

  log {
    category = "AppServiceAntivirusScanAuditLogs"
    enabled  = false

    #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceAppLogs"
    enabled  = false

    #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceAuditLogs"
    enabled  = false

   #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceConsoleLogs"
    enabled  = false

    #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceFileAuditLogs"
    enabled  = false

   #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceHTTPLogs"
    enabled  = true

   #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServiceIPSecAuditLogs"
    enabled  = false

   #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  log {
    category = "AppServicePlatformLogs"
    enabled  = false

    #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
  metric {
    category = "AllMetrics"
    enabled  = false

    #retention_policy {
    # days    = 0
    # enabled = false
    #}
  }
}


# Create a private endpoint for the Web App
resource "azurerm_private_endpoint" "app_pep" {
  name                = var.app_pep_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  subnet_id = var.pep_subnet_id

  # Configure the private DNS zone and the Web App resource
  private_service_connection {
    name                           = var.app_pep_connection_name
    private_connection_resource_id = azurerm_windows_web_app.web_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "app-service-dns-zone-group"
    private_dns_zone_ids = [var.app_pep_dns_zone_id]
  }
}