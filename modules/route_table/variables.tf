variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}
variable "tags" {
  type        = map(string)
  description = "Map (or convertible object) of tags to apply to Azure-level resources"
}

variable "routetable_name" {
  type = string
}

variable "disable_bgp" {
  type = bool
  default = false
}

variable "routes" {
  type        = list(map(string))
  default     = []
  description = "List of objects that represent the configuration of each route."
  /*ROUTES = [{ name = "", address_prefix = "", next_hop_type = "", next_hop_in_ip_address = "" }]*/
}
