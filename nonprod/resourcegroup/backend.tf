#
# For Terraform 1.18 and Azure provider 3.2.0 
#
 terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.3.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">=1.0.0"
    }
  }
}

  # Configure the Microsoft Azure Provider
  provider "azurerm" {
    features {}
  }
# Configure azure api
provider "azapi" {
}
#
# For Terraform 1.17 and Azure provider 3.0.0 
#
##########################################################

###########################################################
#  Use Terraform remote state from Azure storage account
#
terraform {
  backend "azurerm" {
    storage_account_name = "emoneyc796b061tfstg"   # update this value after you create a storage account and get it from Azure portal
    container_name       = "terraform"
    key                  = "rsgnprd.terraform.tfstate"  #this key must be unique for each layer
    resource_group_name  = "RAX-NPRD-ALL"   #variable cannot be used in here, it need to hard code in here.
     
    // obtain storage access_key from storage account (the following system valiable is for Linux enviornment)  
    // export ARM_ACCESS_KEY=XXXXXYYYYYYY
    // $env:ARM_ACCESS_KEY="XXXYYY"
  }
}