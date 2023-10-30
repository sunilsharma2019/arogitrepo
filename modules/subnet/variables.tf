variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "subnets" {
  type = list(object({
    name                      = string
    subnet_prefix             = list(string)
    endpoint_network_policies = bool
    service_network_policies  = bool
    service_delegation        = bool
    service_delegation_name   = string
    service_delegation_action = list(string) 
  }))
}

variable "vnet_name" {
  type = string
}
