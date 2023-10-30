variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource Group which we will deploy resources into."
}

variable "storage_account_name" {
    type = string
}

variable "flow_logs_container_name" {
    type = string
}

variable "nsg_id" {
    type = string
}

variable "network_watcher_name" {
    type = string
}

variable "flow_log_name" {
    type = string
}