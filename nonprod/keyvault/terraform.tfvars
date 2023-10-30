keyvault = {
  name                       = "kvlt-eandmoney-nonprd-01"
  sku                        = "premium"
  soft_delete_enabled        = true
  soft_delete_retention_days = 90
}

keyvault_access = [
  #  {
  #    ad_object_id     = "" # 
  #    has_admin_access = true
  #  },
  {
    ad_object_id     = "f1c8e3e3-0a3c-401a-b880-8843365b340f" # "Rahul Gurunule ID"
    has_admin_access = true
  }
]

############# Resource Group ###############
rg1 = {
  name     = "rg-eandmoney-NonProd-01"
  location = "east us"
}


global_tags = {
  "CostCenter"         = 17806
  "Description"        = "e&money services"
  "ApplicationName"    = "e&money UAE"
  "ApplicationOwner"   = "Rami Basheer Alhasan <ralhasan@eand.com>"
  "TechnicalContact"   = "e&Money <e&Money@eand.com>"
  "ServiceProvider"    = "RXT will take care"
  "Environment"        = "Non Prod"
  "ServerRole"         = "e&money, operation team will provide the details base on sizing and VM`s deployed with help of RXT build team"
  "CriticalityLevel"   = "e&money, operation team will provide the details base on sizing and VM`s deployed with help of RXT build team"
  "CreationDate"       = "RXT will take care"
  "DepartmentEmail"    = "e&Money <e&Money@eand.com>"
  "DataClassification" = ""
  "MaintenanceWindow"  = "Not applicable."
}

#################### Secret ##################3

secret_name      = "pull-secret"
pull_secret_file = "C:/Users/suni1641/OneDrive - Rackspace Inc/Documents/Build/e&walletmoney/Build/pull-secret.txt" # Replace with the actual path to your file
