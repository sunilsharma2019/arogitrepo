#########
# Tagging
#########

variable "tag_buildby" {
  type        = string
  description = "Name of the builder."
}

variable "tag_buildticket" {
  type        = string
  description = "Ticket Number for the build"
}

variable "tag_builddate" {
  type        = string
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "tag_custom" {
  description = "Additional tags to add to the resource."
  type        = map(string)
  default     = {}
}

variable "environment" {
  type        = string
  description = "Prod,QA,STG,DEV,etc."
}

variable "location" {
  type        = string
  description = "Azure region to deploy the resource."
}

##########
# Resource
##########

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry to create."
}

variable "acr_rsg" {
  type        = string
  description = "Resource Group to create the Azure Container Registry in."
}

variable "acr_sku" {
  type        = string
  description = "SKU of the container registry. Either Basic, Standard, or Premium."
  default     = "Standard"
}

variable "acr_admin_user" {
  type        = bool
  description = "Enable the admin user."
  default     = false
}

variable "georeplications" {
  type = list(object({
    location                = string
    zone_redundancy_enabled = optional(bool)
  }))
  description = "A list of properties of the geo-replication blocks for this Container Registry. Only available for the Premium SKU."
  default     = []
}


variable "network_rules_subnet" {
  type        = list(string)
  description = "List of subnets which can access the container registry. Service Endpoint Microsoft.ContainerRegistry must be configured on the subnet. Only available with the Premium SKU."
  default     = []
}

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

############### Diagnostic Settings ########################
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to."
  type        = string
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