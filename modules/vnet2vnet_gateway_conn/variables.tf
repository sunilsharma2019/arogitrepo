variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "type" {
  type = list(string)
}

variable "connection_name" {
  type = list(string)
}

variable "virtual_network_gateway_id" {
  type = list(string)
}

variable "peer_virtual_network_gateway_id" {
  type = list(string)
}

variable "shared_key" {
  type = list(string)
}