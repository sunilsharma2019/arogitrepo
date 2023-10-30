variable "environment" {
  description = "Production, Development, etc"
}

variable "tag_buildby" {
  description = "Racker that built the resource."
}

variable "tag_buildticket" {
  description = "Build ticket number."
}

variable "tag_builddate" {
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "global_tags" {
  description = "Additional tags to add to the resource."
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the Virtual Network Gateway."
}

variable "location" {
  description = "Region to deploy into."
}

variable "storage_rsg" {
  description = "Name of the Resource Group to create in."
}

variable "account_kind" {
  description = "Kind of account. Either Storage, StorageV2, BlobStorage, or FileStorage."
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Performance tier. Either Standard or Premium."
  default     = "Standard"
}

variable "replication_type" {
  description = "Type of replication. Either LRS, GRS, RAGRS, or ZRS."
  default     = "LRS"
}

variable "access_tier" {
  description = "Either Hot or Cool."
  default     = "Hot"
}
variable "data_lake" {
  description = "Is Hierarchical Namespace enabled? This is used with Azure Data Lake Storage Gen 2. Valid Answers are True or False"
  default = false
}