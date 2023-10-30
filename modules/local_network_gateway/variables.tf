variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "gateway" {
  type = list(object({
    address_space = list(string)
  }))
}

variable "local_gateway_name" {
  type = list(string)
}

variable "gateway_address" {
  type = list(string)
}