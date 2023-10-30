
########### ARO Cluster  ###############
module "aro" {
  source = "../../modules/aro"
  # aro_rp_app          = var.aro_rp_app
  virtual_network_id    = data.azurerm_virtual_network.virtual_network.id
  domain                = var.domain
  arocluster_name       = var.arocluster_name
  location              = var.location
  resource_group_id     = data.azurerm_resource_group.rsg.id
  environment           = var.environment
  tag_buildby           = var.tag_buildby
  tag_buildticket       = var.tag_buildticket
  tag_builddate         = var.tag_builddate
  global_tags           = var.global_tags
  pull-secret           = data.azurerm_key_vault_secret.pull-secret.value
  pod_cidr              = var.pod_cidr
  service_cidr          = var.service_cidr
  master_vmsize         = var.master_vmsize
  master_subnet_id      = data.azurerm_subnet.master_subnet.id
  worker_profile_name   = var.worker_profile_name
  worker_node_vm_size   = var.worker_node_vm_size
  woker_node_diskSizeGB = var.woker_node_diskSizeGB
  worker_node_count     = var.worker_node_count
  worker_subnet_id      = data.azurerm_subnet.worker_subnet.id
  arocluster_id         = module.aro.exports.id
  master_encryption_at_host = "Enabled"
  worker_encryption_at_host = "Enabled"
  # api_server_visibility = var.api_server_visibility
  # ingress_visibility = var.ingress_visibility
}









/*

# terraform {
#   required_version = ">= 1.0"
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = ">=3.3.0"
#     }
#     azapi = {
#       source  = "Azure/azapi"
#       version = ">=1.0.0"
#     }
#   }
# }

# provider "azurerm" {
#   features {}
# }

# provider "azapi" {
# }

data "azurerm_client_config" "current" {
}

locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/aro-${var.domain}-${var.location}"
}

resource "random_string" "resource_prefix" {
  length  = 6
  special = false
  upper   = false
  numeric = false
}

# resource "azurerm_resource_group" "net" {
#   name     = var.netrg
#   location = var.location
# }

# resource "azurerm_log_analytics_workspace" "oms" {
#   name                = "eandmoney-oms"
#   location            = var.location
#   resource_group_name = azurerm_resource_group.net.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }
# resource "azurerm_virtual_network" "virtual_network" {
#   name                = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}VNet"
#   address_space       = var.virtual_network_address_space
#   location            = var.location
#   resource_group_name = azurerm_resource_group.net.name
#   tags                = var.tags

#   lifecycle {
#     ignore_changes = [
#       tags
#     ]
#   }
# }

# resource "azurerm_subnet" "master_subnet" {
#   name                                          = var.master_subnet_name
#   resource_group_name                           = azurerm_resource_group.net.name
#   virtual_network_name                          = azurerm_virtual_network.virtual_network.name
#   address_prefixes                              = var.master_subnet_address_space
#   service_endpoints                             = ["Microsoft.ContainerRegistry"]
#   private_link_service_network_policies_enabled = false
#   depends_on                                    = [azurerm_virtual_network.virtual_network]
# }

# resource "azurerm_subnet" "worker_subnet" {
#   name                 = var.worker_subnet_name
#   resource_group_name  = azurerm_resource_group.net.name
#   virtual_network_name = azurerm_virtual_network.virtual_network.name
#   address_prefixes     = var.worker_subnet_address_space
#   service_endpoints    = ["Microsoft.ContainerRegistry"]
#   depends_on           = [azurerm_virtual_network.virtual_network]
# }

# Create an Azure AD application
resource "azuread_application" "aro_rp_app" {
  display_name = "aro_rp_app"
  owners       = [data.azuread_client_config.current.object_id]
}
# Create a service principal for the app 
resource "azuread_service_principal" "aro_rp_app" {
  application_id               = azuread_application.aro_rp_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}
# Generate a client secret password
resource "azuread_service_principal_password" "aro_rp_app_pass" {
  service_principal_id = azuread_service_principal.aro_rp_app.object_id
}

output "key_id" {
  value = azuread_service_principal_password.aro_rp_app_pass.key_id
}

output "key_value" {
  value     = azuread_service_principal_password.aro_rp_app_pass.value
  sensitive = true
}

data "azuread_service_principal" "aro_rp_app" {
  display_name = "Azure Red Hat OpenShift RP"
  depends_on   = [azuread_service_principal.aro_rp_app]
}

# resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
#   scope                = azurerm_virtual_network.virtual_network.id
#   role_definition_name = "Contributor"
#   principal_id         = data.azuread_service_principal.aro_app.id
#   skip_service_principal_aad_check = true
# }
# Peer the ARO VNet to another VNet 
# resource "azurerm_virtual_network_peering" "aro_peer" {
#   name                      = "aro-peer"
#   resource_group_name       = azurerm_resource_group.net.name
#   virtual_network_name      = azurerm_virtual_network.virtual_network.name
#   remote_virtual_network_id = var.peerVnetId
# }

resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
  scope                            = data.azurerm_virtual_network.virtual_network.id
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
  scope                            = data.azurerm_virtual_network.virtual_network.id
  role_definition_name             = "Contributor"
  principal_id                     = data.azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}



resource "azapi_resource" "aro_cluster" {
  name      = "${var.resource_prefix != "" ? var.resource_prefix : random_string.resource_prefix.result}Aro"
  location  = var.location
  parent_id = data.azurerm_resource_group.rsg.id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
  tags      = var.tags
    timeouts {
    create = "75m"
  }
  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = var.domain
        fipsValidatedModules = "Enabled"
        resourceGroupId      = local.resource_group_id
        pullSecret           = data.azurerm_key_vault_secret.pull-secret.value
      }
      networkProfile = {
        podCidr     = var.pod_cidr
        serviceCidr = var.service_cidr
      }
      servicePrincipalProfile = {
        clientId     = azuread_service_principal.aro_rp_app.application_id
        clientSecret = azuread_service_principal_password.aro_rp_app_pass.value
      }
      masterProfile = {
        vmSize = "Standard_D8s_v3" # Replace with your desired VM size
        # osDiskSizeGB          = 1024  # P10 disk size (1024 GB)
        subnetId         = data.azurerm_subnet.master_subnet.id
        encryptionAtHost = "Disabled"
      }
      workerProfiles = [
        {
          name             = var.worker_profile_name
          vmSize           = var.worker_node_vm_size
          diskSizeGB       = 128
          subnetId         = data.azurerm_subnet.worker_subnet.id
          count            = 3
          encryptionAtHost = "Disabled"
        }
      ]
      apiserverProfile = {
        visibility = var.api_server_visibility
      }
      ingressProfiles = [
        {
          name       = var.ingress_profile_name
          visibility = var.ingress_visibility
        }
      ]
    }
  })
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
  depends_on = [
    data.azurerm_subnet.worker_subnet,
    data.azurerm_subnet.master_subnet,
    azuread_service_principal_password.aro_rp_app_pass,
    azurerm_role_assignment.aro_resource_provider_service_principal_network_contributor
  ]
}

# resource "time_sleep" "wait_120_minutes" {
#   depends_on = [azapi_resource.aro_cluster]

#   create_duration = "120m"
# }

resource "azapi_resource_action" "test" {
  type                   = "Microsoft.RedHatOpenShift/openShiftClusters@2023-07-01-preview"
  resource_id            = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/openenv-${var.guid}/providers/Microsoft.RedHatOpenShift/openShiftClusters/aro-cluster-${var.guid}"
  action                 = "listAdminCredentials"
  method                 = "POST"
  response_export_values = ["*"]
  depends_on             = [azapi_resource.aro_cluster]
}

output "kubeconfig" {
  value = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
}

resource "local_file" "kubeconfig" {
  content    = base64decode(jsondecode(azapi_resource_action.test.output).kubeconfig)
  filename   = "kubeconfig"
  depends_on = [azapi_resource_action.test]
}

output "domain" {
  value = var.domain
}

*/