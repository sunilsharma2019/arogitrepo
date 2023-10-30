variable "key_vault_id" {
  type        = string
  description = "ID of the KeyVault the secrets will be stored in"
}

variable "key_vault_secrets" {
  type        = map(string)
  description = "A list of maps including string(secret_name), string(secret_value) and Tags"
}
