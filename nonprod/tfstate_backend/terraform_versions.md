# #########################################################
#
# For Terraform 0.12.29 and Azure provider 2.0.0 
#
  provider "azurerm" {
    version = "2.0.0"
    features {}

    # If you use Service Principie (SPN) for authenication, unremark the following variables.
    #  subscription_id = var.subscription_id
    #  client_id = var.client_id
    #  client_secret = var.client_secret
    #  tenant_id = var.tenant_id
  }

  # use terraform 0.12
  terraform {
    required_version = ">= 0.12"
  }
#
# For Terraform 0.12.29 and Azure provider 2.0.0 
#
# #########################################################

# #########################################################
#
# For Terraform 1.18 and Azure provider 3.2.0 
#
  terraform {
    required_version = ">= 1.1.8"
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = "=3.2.0"
      }
      random = {
        source  = "hashicorp/random"
        version = "=3.1.0"
      }
    }
  }

  # Configure the Microsoft Azure Provider
  provider "azurerm" {
    features {}
  }
#
# For Terraform 1.17 and Azure provider 3.0.0 
#
# ########################################################
