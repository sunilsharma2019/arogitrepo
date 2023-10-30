variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "peering" {
  type = list(object({
    name                    = string
    remote_vnet_name        = string
    use_remote_gateways     = bool
    allow_gateway_transit   = bool
    allow_forwarded_traffic = bool
  }))
}

variable "peering_vnet_name" {
  type = string
}


