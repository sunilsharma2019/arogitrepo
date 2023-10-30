variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."

}
variable "recovery_vault_name" {
  type        = string
}

variable "backup_policy_name" {
  type        = string
}

variable "soft_delete_enabled" {
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    Source       = "terraform"
    Environment  = "QAS"
    Company      = "PFS"
  }
}