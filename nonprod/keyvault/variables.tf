#############Azure Keyvault Variables ################

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

############################# Global Tags #################################

variable "global_tags" {
  type        = map(any)
  description = "(Optional) A map of tags to be applied globally on all Azure resources"
  default     = {}
}
############ Resource Group variables ################
variable "rg1" {
  type = object({
    name     = string
    location = string
  })
}

################### Secret Pull-Secret ###########333

variable "secret_name" {
  description = "Name of the secret"
}

variable "pull_secret_file" {
  description = "Path to the pull-secret file"
  type        = string
}

