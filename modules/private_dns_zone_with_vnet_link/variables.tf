variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."
}

variable "private_dns_zone_name" {
    type = string
}

variable "vnet_link" {
  type = list(object({
    name    = string
    ids     = string
  }))
}