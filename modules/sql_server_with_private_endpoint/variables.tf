variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."
}

variable "sql_server_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type = string
}

variable "sql_pep_nic_name" {
  type = string
}

variable "pep_subnet_id" {
  type = string
}

variable "sql_pep_name" {
  type = string
}

variable "sql_pep_connection_name" {
  type = string
}

variable "sql_pep_dns_zone_id" {
    type = string
}

variable "public_network_access_enabled" {
    type = bool
    default = false
}