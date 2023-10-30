variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."
}

variable "nat_pub_ip_name" {
  type = string
}

variable "pip_sku" {
  type = string
}

variable "nat_attach_subnet" {
  type = list(string)
}

variable "nat_gw_name" {
  type = string
}