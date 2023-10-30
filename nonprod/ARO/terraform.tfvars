domain   = "aroeandmoney"
location = "eastus"
# aro_rp_app      = "aro_rp_app"

######## ARO cluster Name
arocluster_name = "aroeandmoney"


############# Tags #########################
environment     = "Non Prod"
tag_buildby     = "Sunil Sharma"
tag_buildticket = "1234-ord-1234"
tag_builddate   = "18-10-2023"


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

pod_cidr     = "10.128.0.0/14"
service_cidr = "172.30.0.0/16"

master_vmsize = "Standard_D8s_v3"

worker_profile_name = "worker"

worker_node_vm_size = "Standard_D8s_v3"

woker_node_diskSizeGB = 128

worker_node_count = 3

/*

domain = "emoneytestaro"

location                      = "eastus"
resource_prefix               = "emoneyaro"
virtual_network_address_space = ["10.217.16.0/20"]
netrg                         = "emoney-netrg"
master_subnet_name            = "emoney-mastersnet"

vnet_name                   = "vnet"
worker_subnet_name          = "emoney-workersnet"
master_subnet_address_space = ["10.217.16.0/24"]
worker_subnet_address_space = ["10.217.17.0/24"]

# workspaceResourceId = "log-workspace"

# aadTenantId = ""
# aadClientId = "9bbb8a41-49f6-46bf-8ace-3a5286dd8b5b"
# aro_cluster_aad_sp_client_secret = "bdr8Q~tuSgpPKc3czZk9rR6FzgDBIhjDZtHHOboe"

# aadCustomerAdminGroupId      = "b9d1bc00-5d58-4ab0-8798-c61efec8097a"
# aro_cluster_aad_sp_object_id = "30ab1ada-07b1-4eef-a7e4-850e120c8c34"
# computeNodeType = "Standard_D4s_v3"

# aro_cluster_aad_sp_client_id = "30ab1ada-07b1-4eef-a7e4-850e120c8c34"

master_node_vm_size      = "Standard_D8s_v3"
clusterName              = "emoneytestaro"
worker_profile_name      = "worker"
master_profile_name      = "master"
worker_node_vm_size      = "Standard_D8s_v3"
worker_node_vm_disk_size = 128

api_server_visibility = "Public"
ingress_profile_name  = "default"
ingress_visibility    = "Public"
pod_cidr              = "10.128.0.0/14"
service_cidr          = "172.30.0.0/16"
# peerVnetId            = "/subscriptions/37f26f9f-6c7c-4be6-9442-56e71b2d14e2/resourceGroups/emoney-netrg/providers/Microsoft.Network/virtualNetworks/eandmoney-nonpro-vnet"


############### Tags ######


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
*/