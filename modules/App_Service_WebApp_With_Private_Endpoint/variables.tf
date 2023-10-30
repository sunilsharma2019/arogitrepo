variable "app_service_name" {
  type = string
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource Group which we will deploy resources into."
}

variable "app_subnet_id" {
  type = string
}

variable "pep_subnet_id" {
  type = string
}

variable "app_pep_name" {
  type = string
}

variable "app_service_diag_name" {
  type = string
}

variable "app_pep_connection_name" {
  type = string
}

variable "app_pep_dns_zone_id" {
  type = string
}

variable "lgw_id" {
  type = string
}

variable "service_plan_id" {
  type = string
}
variable "app_insight_name" {
  type = string
}

variable "app_settings_SystemName" {
  type = string
}

variable "app_settings_WEBSITE_ENABLE_SYNC_UPDATE_SITE" {
  type = string
}
variable "app_settings_serilog" {
  type = string
}

variable "virtual_applications" {
  type = list(object({
    preload       = string
    physical_path = string
    virtual_path  = string

  }))
}

variable "ip_restrictions" {
  type = list(object({
    action     = string
    ip_address = string
    name       = string
    priority   = number
  }))
}

variable "scm_ip_restrictions" {
  type = list(object({
    action     = string
    ip_address = string
    name       = string
    priority   = number
  }))
}
