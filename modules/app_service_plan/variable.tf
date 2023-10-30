variable "app_service_plan_name" {
  type = string
}

variable "app_service_sku_name" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource Group which we will deploy resources into."
}