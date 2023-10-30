variable "name" {
  type        = string
  description = "A valid name for the bastion"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}

variable "tags" {
  type        = map(string)
  description = "Dictionary of relevant tags"
}

variable "custom_rules" {
  description = "Security rules for the network security group using this format name = [priority, direction, access, protocol, source_port_range, destination_port_range, src_address_prefix, destination_address_prefix, description]"
  type        = any
  default     = []
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}
