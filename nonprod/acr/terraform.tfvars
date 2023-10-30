registry_name = "acreandmoneynprd"
location      = "eastus"
# resource_group_name = "rg-eandmoney-NonProd-01"
georeplications = [
  {
    location                = "East US 2"
    zone_redundancy_enabled = true
  },
  {
    location                = "West US"
    zone_redundancy_enabled = true
  }
]


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

environment     = "Non Pord"
tag_buildby     = "Sunil Sharma"
tag_buildticket = "1234-test-1234"
tag_builddate   = "17-10-2023"

############### network_rules_subnet

# network_rules_subnet = ["/subscriptions/37f26f9f-6c7c-4be6-9442-56e71b2d14e2/resourceGroups/rg-eandmoney-NonProd-01/providers/Microsoft.Network/virtualNetworks/vnet-eandmoney-nonprod-01/subnets/ARO-MASTERS-SN", "/subscriptions/37f26f9f-6c7c-4be6-9442-56e71b2d14e2/resourceGroups/rg-eandmoney-NonProd-01/providers/Microsoft.Network/virtualNetworks/vnet-eandmoney-nonprod-01/subnets/ARO-WORKERS-SN"]
network_rules_ip     = ["120.136.32.106"]

#####
sku = "Premium"