resource "azurerm_backup_protected_vm" "vm" {
  count               = length(var.target_vms)
  resource_group_name = var.resource_group.name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = var.target_vms[count.index]
  backup_policy_id    = var.backup_policy_id
}