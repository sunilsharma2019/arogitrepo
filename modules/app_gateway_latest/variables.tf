variable "app_gateway_name" {
  type        = string
  description = "The name of the Application Gateway."
}

variable "appgw_public_ip" {
  type        = string
  description = "The name of the Application Gateway public IP."
}

variable enable_http2 {
  type = bool 
  default = false
}

variable "app_gateway_min_capacity" {
  type    = string
}

variable "app_gateway_max_capacity" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

variable "sku_name" {
  type        = string
  description = "The SKU name for the Application Gateway."
}

variable "sku_tier" {
  type        = string
  description = "The SKU tier for the Application Gateway."
}

variable "sku_capacity" {
  type        = number
  description = "The SKU capacity for the Application Gateway."
}

variable "frontend_ports" {
  type        = list(object({
    name = string
    port = number
  }))
  description = "A list of frontend ports."
}

variable "frontend_ip_configurations" {
  type        = list(object({
    name                 = string
    public_ip_address_id = string
  }))
  description = "A list of frontend IP configurations."
}

variable "ssl_certificates" {
  type        = list(object({
    name     = string
    key_vault_secret_id = string
#    data     = string
#    password = string
  }))
  description = "A list of SSL certificates."
}

variable "http_listeners" {
  type        = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    host_name                      = optional(string)
    host_names                     = list(string)
    ssl_certificate_name           = string
    require_sni                    = bool
  }))
  description = "A list of HTTP listeners."
}

variable "backend_address_pools" {
  type        = list(object({
    name = string
    fqdns = list(string)
    ip_addresses = list(string)
  }))
  description = "A list of backend address pools."
}

variable "backend_http_settings" {
  type        = list(object({
    name                  = string
    cookie_based_affinity = string
    pick_host_name_from_backend_address = bool
    probe_name                  = string
    protocol              = string
    request_timeout       = number
    port                  = number
    affinity_cookie_name  = optional(string)
  }))
  description = "A list of backend HTTP settings collections."
}

variable "request_routing_rules" {
  type        = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    priority                   = number
    backend_address_pool_name  = optional(string)
    backend_http_settings_name = optional(string)
    url_path_map_name = optional(string)
  }))
  description = "A list of request routing rules."
}
/*
variable "redirect_configuration" {
  type        = list(object({
      name                  = string
      redirect_type         = string
      target_listener_name  = string
      target_url            = string
      include_path          = bool
      include_query_string = bool
  }))
  description = "A list of redirection rules."
}
*/
variable "url_path_maps" {
  type        = list(object({
    name = string
    default_backend_address_pool_name    = string
    default_backend_http_settings_name   = string
    path_rule = object({
          name                        = string
          paths                       = list(string)
          backend_address_pool_name      = string
          backend_http_settings_name     = string
    })
  }))
  description = "A list of URL path maps."
}

variable "probes" {
  type        = list(object({
    name                                  = string
    protocol                              = string
#    host                                  = string
    path                                  = string
    interval                              = number
    timeout                               = number
    unhealthy_threshold                   = number
    pick_host_name_from_backend_http_settings = bool
    match = object({
      status_code = list(string)
    })
  }))
  description = "A list of probes."
}

variable "gateway_ip_configurations" {
  type        = list(object({
    name      = string
    subnet_id = string
  }))
  description = "A list of gateway IP configurations."
}


variable "loganalytics_id" {
  type = list(string)
}

variable "firewall_mode" {
 type = string
 default = "Detection"
}

variable "waf_configuration_enabled" {
 type = bool
 default = true
}

variable "waf_rule_set_version" {
  type = string
  default = "3.2"
}

variable "identity_ids" {
  type = list(string)
}

variable "identity_type" {
  type = string
  default = "UserAssigned"
}


variable "custom_rules" {
  description = "One or more custom_rule blocks."
  # type        = list(any)
  type = list(object({
    name     = string # required
    action   = string # required
    # enabled  = bool   # optional
    priority = number # required but default to 1 ?!
    type     = string # required
    match_conditions = list(object({
      match_variables = list(object({
        variable_name  = string
        })) # required
      match_values       = list(string)   # required
      operator           = string # required
      # selector           = string # optional
      negation_condition = bool   # optional default to false ?
      transforms         = list(string)   # optional
    })
    )
    # rate_limit_duration_in_minutes = number # optional - defaults to 1
    rate_limit_threshold           = number # optional - defaults to 10
  }))
  default = []
}

variable "mode" {
  default = "Detection"
}