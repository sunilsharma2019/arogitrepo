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