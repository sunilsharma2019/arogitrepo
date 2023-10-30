variable "registry_name" {
  description = "The name of this Container Registry."
}

variable "location" {
  description = "The supported Azure location where the resources exist."
  type        = string
}

# variable "resource_group_name" {
#   description = "The name of the resource group in which to create the resources."
#   type        = string
# }


variable "sku" {
  description = "The SKU tier for the Container Registry."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Is admin enabled for this Container Registry?"
  type        = bool
  default     = false
}

variable "georeplications" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool, false)
  }))
  default = []
}


########## Tags ###################################################################################

variable "environment" {
  description = "Production, Development, etc"
}

variable "tag_buildby" {
  description = "Racker that built the resource."
}

variable "tag_buildticket" {
  description = "Build ticket number."
}

variable "tag_builddate" {
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "global_tags" {
  description = "Additional tags to add to the resource."
  type        = map(string)
  default     = {}
}


variable "diagnostic_setting_enabled_log_categories" {
  description = "A list of log categories to be enabled for this diagnostic setting."
  type        = list(string)

  default = [
    "ContainerRegistryLoginEvents",
    "ContainerRegistryRepositoryEvents"
  ]
}

variable "diagnostic_setting_name" {
  description = "The name of this Diagnostic Setting."
  type        = string
  default     = "audit-logs"
}


# variable "log_analytics_workspace_id" {
#   description = "The ID of the Log Analytics workspace to send diagnostics to."
#   type        = string
# }

########## network_rules_subnet ##########


# variable "network_rules_subnet" {
#   type        = list(string)
#   description = "List of subnets which can access the container registry. Service Endpoint Microsoft.ContainerRegistry must be configured on the subnet. Only available with the Premium SKU."
#   default     = []
# }

variable "network_rules_ip" {
  type        = list(string)
  description = "List of external IP CIDR blocks which can access the container registry. Private allocations defined in RFC 1918 are not allowed. Only available with the Premium SKU."
  default     = []
}

variable "network_rules_default_allow" {
  type        = bool
  description = "Allow or deny requests if no rule matches. Only applies if network_rules_subnet or network_rules_ip variable is defined. true to allow by default, false to deny by default."
  default     = false
}

