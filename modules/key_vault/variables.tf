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

variable "loganalytics_id" {
  type = list(string)
}
