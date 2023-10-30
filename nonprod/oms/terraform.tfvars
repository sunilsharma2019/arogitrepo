################### Loganalytics ############

loganalytics_name = "oms-eandmoney-nonprod-01"
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
