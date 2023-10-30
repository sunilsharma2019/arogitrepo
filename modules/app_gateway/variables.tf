variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
}

#variable "certpass" {
#  type    = string
#  default = "edge-dev"
#}

variable "appgwconfig" {
  type    = string
  description = "Application Gateway config name"
}

variable "app_gateway_name" {
  type    = string
  description = "Name of the Application Gateway"
}

variable "app_gateway_sku" {
  type    = string
  description = "Name of the Application Gateway SKU"
  default     = "WAF_v2"
}

variable "app_gateway_min_capacity" {
  type    = string
}

variable "app_gateway_max_capacity" {
  type = string
}

#variable "app_gateway_tier" {
#  type    = string
#  description = "Tier of the Application Gateway tier"
#  default     = "Standard_v2"
#}

variable "appgw_public_ip" {
  type    = string
  description = "Public ip name."
}

# variable "manage_k8s_uid" {
#   type    = string
# }

variable "appgw_subnet_id" {
  type = string
}

# variable "keyvault_id" {
#   type = string
# }

# variable "principal_id_uid" {
#   type = string
# }

#variable "appgw_ssl_certificate_name" {
#  type = string
#}

variable enable_http2 {
  type = bool 
  default = false
}

variable port {
  type = number 
  default = 443
}

variable request_timeout {
  type = number 
  default = 120
}

variable protocol {
  type = string 
  default = "Https"
}

variable cookie_based_affinity {
  type = string 
  default = "Disabled"
}

#variable ssl_certificate_id {
#  type = string 
#}

variable http_listener_name {
  type = string 
}


# variable "appgw_private_ip" {
#   type = string
# }

variable "loganalytics_id" {
  type = list(string)
}

# variable "rewrite_rule_name" {
#   type = string
# }

variable "firewall_mode" {
 type = string
 default = "Detection"
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