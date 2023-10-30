/*
  To use Terraform with Azure:

  1) Logon using Azure CLI:
    az login  
    az account list --output table 
    az account set -s "[your Azure subscription ID]" #Your Subscription ID. e.g. 8f40bfae-178d-4b56-8d5c-a1c4addb034c is RS testing subscription.
    az account show  
  
  or

  2) You can logon using Azure Service Principle, i.e. SPN (created with Contribution or Gloabl Admin permission)
  e.g.
    
      az login
      az account list --output table
      az account set --subscription="8f40bfae-178d-4b56-8d5c-a1c4addb034c"  # Rackspace testing subscription.
      az account show  

    #This create service principle for terrform to logon programically with CONTRIBUTOR
   
      az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c"  
    
      e.g.

        {
          "appId": "4515fff8-3029-4de9-bd50-c91cc0935835",      <= This is CLIENT_ID
          "displayName": "azure-cli-2020-04-28-07-07-35",
          "name": "http://azure-cli-2020-04-28-07-07-35",
          "password": "65a4f3f9-881d-406d-9244-4707aaf9529a",   <= This is CLIENT_SECRET
          "tenant": "570057f4-73ef-41c8-bcbb-08db2fc15c2b"      <= This is TENANT_ID
        }

    Then logon using 
    
      az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID 

  or

  3) Get CLIENT_ID, CLIENT_SECRET, TENANT_ID from Janus V2 portal and add to your Terraform code provider "azurerm" 

  Other terrform gotchs:

    1) To test access to Azure enviornment:

      You can test access to Azure via the following command (This only shown you can access Azure enviornment, but it does not means you can acces your desire subscription resources)

        az vm list-sizes --location eastasia

    2) To import existing resources to Terraform:
      
      terraform import azurerm_resource_group.rsg_web /subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-WEB-PRD

      terraform import azurerm_resource_group.rsd_app /subscriptions/8f40bfae-178d-4b56-8d5c-a1c4addb034c/resourceGroups/FC-EA-RSG-APP-PRD
      
    3) To delete a resource on terraform state (it may need if you removed an resource on Azure portal):
      
      terraform state rm "module.res-vm"
*/
##########################################################
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
# For Terraform 1.17 and Azure provider 3.0.0 
#
##########################################################

resource "random_id" "storage" {
  byte_length = 4
}

resource "azurerm_resource_group" "mgmt" {
  name = "RAX-NPRD-ALL"
  location = var.location
  tags = var.rsg_tags_tf
}
resource "azurerm_storage_account" "my-terraform-state-storage" {
  name                     = "emoney${lower(random_id.storage.hex)}tfstg"
  resource_group_name      = azurerm_resource_group.mgmt.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.rsg_tags_tf
}

resource "azurerm_storage_container" "my-terraform-state-storage" {
  name = "terraform"
  storage_account_name = azurerm_storage_account.my-terraform-state-storage.name
}

// For 1st time you run your code with Terrform, the following terraform {} must be comment to let Terraform create local state files. Then Uncomment the following block once above storage account was created. Your Terraform local state will be moved to remote state file on Azure storage account. (i.e. execute "terraform init" command and obtain a storage account ID from Terraform output)
/*
terraform {
  backend "azurerm" {
    storage_account_name = "rackspaceXXXXXXXX"   # update this value after you create a storage account and get it from Azure portal
    container_name       = "terraform"
    key                  = "base.terraform.tfstate"  #this key must be unique for each layer
    resource_group_name  = "XXXXXXXXXXXXXXXX"   #variable cannot be used in here, it need to hard code in here.
     
    // obtain storage access_key from storage account (the following system valiable is for Linux enviornment)  
    // export ARM_ACCESS_KEY=XXXXXYYYYYYY
    // $env:ARM_ACCESS_KEY="XXXYYY"
  }
}
*/

//This terraform {...} section need to be removed for 1st time you run "terraform init"
terraform {
  backend "azurerm" {
    storage_account_name = "emoneyc796b061tfstg"   # update this value after you create a storage account and get it from Azure portal
    container_name       = "terraform"
    key                  = "base.terraform.tfstate"  #this key must be unique for each layer
    resource_group_name  = "RAX-NPRD-ALL"   #variable cannot be used in here, it need to hard code in here.
     
    // obtain storage access_key from storage account (the following system valiable is for Linux enviornment)  
    // export ARM_ACCESS_KEY=XXXXXYYYYYYY
    // $env:ARM_ACCESS_KEY="XXXYYY"
  }
}
