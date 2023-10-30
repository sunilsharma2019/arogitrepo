#############Azure loganalytics Variables ################

variable "loganalytics_name" {
  type = string
}
variable "loganalytics_settings" {
  type = object({
    sku            = string
    retention_days = number
  })
  default = {
    retention_days = 30
    sku            = "PerGB2018"
  }
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

