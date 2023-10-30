variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object describing the Resource Group which we will deploy resources into."
}

variable "subnet_id" {
  description = "Name of the subnet for the database migration service and project."
  type        = string
}

variable "service_name" {
  description = "Name of the Azure Database Migration Service."
  type        = string
}

variable "projects" {
  description = "List of Azure Database Migration Projects."
  type        = list(object({
    name = string
    source_platform = string
    target_platform = string
    // Add additional project-specific variables here
  }))
}

variable "tags" {
  description = "Tags to associate with the resources."
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "Name of the SKU for the database migration service."
  type        = string
}

