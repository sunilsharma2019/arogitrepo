variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource group name and location we are deploying in."

}

variable "tags" {
  type        = map(string)
  description = "Map (or convertible object) of tags to apply to Azure-level resources"
}
variable "pip_name" {
  type = string

}

variable "pip_allocation_method" {
  type = string
  
}

variable "pip_sku" {
  type = string
  
}

variable "loadbalancer_name" {
  type = string

}

variable "loadbalancer_sku" {
  type = string
  
}

variable "web_lb_backend_pool_name" {
  type = string
}

variable "web_vm_nic_id" {
  type = string
}

variable "web_vm_nic_ip_configuration_name" {
  type = string
}