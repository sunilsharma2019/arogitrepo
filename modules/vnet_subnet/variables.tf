variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."
}

variable "subnets" {
  type = list(object({
    name                 = string
    subnet_prefix        = list(string)
#    enforce_private_link = bool
  }))
}

variable "vnet_name" {
  type = string
}

variable "service_endpoints" {
  type = list(string)
  default = []
}