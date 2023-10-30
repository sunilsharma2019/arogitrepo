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

variable "backup_policy_id" {
  type        = string
}

variable "target_vms" {
  type        = list(string)
}

