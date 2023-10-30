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

variable "local_network_gateway_id" {
  type = list(string)
}

#variable "local_address_cidrs" {
#  type = list(object({
#    address_space = list(string)
#  }))
#}

#variable "remote_address_cidrs" {
#  type = list(object({
#    address_space = list(string)
#  }))
#}

variable "shared_key" {
  type = list(string)
}