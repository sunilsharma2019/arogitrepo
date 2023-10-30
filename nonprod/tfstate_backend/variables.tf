#Variables for entire enviroment.

# If you use SPN for authenication, use the following variables.
/*
variable "subscription_id" {
  description = "Enter Subscription ID for provisioning resources in Azure"
}

// optional values
variable "client_id" {
  description = "Enter Client ID for Application created in Azure AD"
}

variable "client_secret" {
  description = "Enter Client secret for Application in Azure AD"
}

variable "tenant_id" {
  description = "Enter Tenant ID / Directory ID of your Azure AD. Run Get-AzureSubscription to know your Tenant ID"
}
*/

variable "location" {
  description = "Azure region the environment."
  default     = ""
}

variable "rsg_tags_tf" {
  type = map(string)
}

variable "rsg_terreform_state" {}


