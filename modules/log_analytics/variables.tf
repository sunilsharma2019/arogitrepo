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
variable "loganalytics_name" {
  type = string
}
variable "loganalytics_settings" {
  type = object({
    sku            = string
    retention_days = number
  })
  default = {
    retention_days = 30
    sku            = "PerGB2018"
  }
}