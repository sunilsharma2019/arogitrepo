variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource Group which we will deploy resources into."
}

variable "keyvault" {
  type = object({
    name                       = string
    sku                        = string
    soft_delete_retention_days = number
    soft_delete_enabled        = bool
  })
  description = "Object describing the Key Vault we want to create."
}

variable "keyvault_access" {
  type = list(object({
    ad_object_id     = string
    has_admin_access = bool
  }))
  description = "List of objects describing the Access Policies we want to create for the Key Vault."
}

variable "tags" {
  type        = map(string)
  description = "Map (or convertible object) of tags to apply to Azure-level resources"
}

# variable "service_connection_id" {
#   type = string
  
# }


############### Diagnostic Settings ########################
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
}

variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)

  default = ["AuditEvent"
  ]
}

variable "diagnostic_setting_name" {
  description = "The name of this Diagnostic Setting."
  type        = string
  default     = "audit-logs"
}