################################
#  Outputs   :
#
#  random_id = "XXXXXX"
#  remote_state_configuration_example = <sensitive>
#  tf_storage_account_name = "rackspaceeXXXXXXX"
#

output "random_id" {
  value = lower(random_id.storage.hex)
}
output "tf_storage_account_name" {
  value = azurerm_storage_account.my-terraform-state-storage.name
}
output "remote_state_configuration_example" {
  sensitive = true
  value = <<EOF
  backend "azurerm" {
    storage_account_name = "${azurerm_storage_account.my-terraform-state-storage.name}"
    container_name       = "terraform"
    key                  = "base.terraform.tfstate"
    
    // obtain storage access_key from storage account (for Linux use)
    // export ARM_ACCESS_KEY="${azurerm_storage_account.my-terraform-state-storage.primary_access_key}"
    // $env:ARM_ACCESS_KEY="${azurerm_storage_account.my-terraform-state-storage.primary_access_key}"
EOF
  description = "A suggested terraform block to put into the build layers"
}

