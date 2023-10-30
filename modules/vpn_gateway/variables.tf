variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "vpn_gw_ip" {
  type = string
}

variable "generation" {
  type = string
}

variable "vpn_subnet_id" {
  type = string
}

variable "vpn_gw_sku" {
  type = string
}

variable "vpn_gw_name" {
  type = string
}