############# Resource Group ###############
rg1 = {
  name     = "rg-eandmoney-NonProd-01"
  location = "east us"
}


############ Tags ######################

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




##########################Virtual Netowrk and Subnet ##########################

vnet01 = {
  name          = "vnet-eandmoney-nonprod-01"
  address_space = ["10.217.16.0/20"]
}

subnets = [
  {
    name                 = "ARO-MASTERS-SN"
    subnet_prefix        = ["10.217.16.0/24"]
    endpoint_network_policies  = false
    service_network_policies   = true
    service_delegation         = false
    service_delegation_name    = ""
    service_delegation_action  = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault","Microsoft.Storage"] 
  },
  {
    name                 = "ARO-WORKERS-SN"
    subnet_prefix        = ["10.217.17.0/24"]
    endpoint_network_policies  = false
    service_network_policies   = false
    service_delegation         = false
    service_delegation_name    = ""
    service_delegation_action  = ["Microsoft.ContainerRegistry", "Microsoft.KeyVault","Microsoft.Storage"] 
  },
#   {
#     name                 = "APIM-SN"
#     subnet_prefix        = ["10.240.1.64/26"]
#     endpoint_network_policies  = false
#     service_network_policies   = false
#     service_delegation         = false
#     service_delegation_name    = ""
#     service_delegation_action  = [""] 
#   },
#   {
#     name                 = "BCKND-DBs-SN"
#     subnet_prefix        = ["10.240.2.0/27"]
#     endpoint_network_policies  = false
#     service_network_policies   = false
#     service_delegation         = false
#     service_delegation_name    = ""
#     service_delegation_action  = [""] 
#   }
#   ,
#   {
#     name                 = "INFRA-SN"
#     subnet_prefix        = ["10.240.1.64/26"]
#     endpoint_network_policies  = false
#     service_network_policies   = false
#     service_delegation         = false
#     service_delegation_name    = ""
#     service_delegation_action  = [""] 
#   },
#   {
#     name                 = "PRIVATE-ENDPOINTS-SN"
#     subnet_prefix        = ["10.240.2.0/27"]
#     endpoint_network_policies  = false
#     service_network_policies   = false
#     service_delegation         = false
#     service_delegation_name    = ""
#     service_delegation_action  = [""] 
#   }
]