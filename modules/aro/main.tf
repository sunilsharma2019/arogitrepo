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

# provider "azurerm" {
#   features {}
# }

# provider "azapi" {
# }

data "azurerm_client_config" "current" {
}

data "azuread_client_config" "current" {}

locals {
  resource_group_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/aro-${var.domain}-${var.location}"
}


resource "azuread_application" "aro_rp_app" {
  display_name = "aro_rp_app"
  owners       = [data.azuread_client_config.current.object_id]
}
resource "azuread_service_principal" "aro_rp_app" {
  application_id               = azuread_application.aro_rp_app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}
resource "azuread_service_principal_password" "aro_rp_app_pass" {
  service_principal_id = azuread_service_principal.aro_rp_app.object_id
}

// (6)
resource "azurerm_role_assignment" "aro_cluster_service_principal_uaa" {
  scope                = var.resource_group_id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor_pre" {
  scope                = var.resource_group_id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}
resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
  scope                = var.virtual_network_id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}
data "azuread_service_principal" "aro_rp_app" {
  display_name = "Azure Red Hat OpenShift RP"
  depends_on = [azuread_service_principal.aro_rp_app]
}
resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
  scope                = var.virtual_network_id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}

/*
# Create an Azure AD application
resource "azuread_application" "aro_rp_app" {
  display_name ="aro_app"
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

output "aro_sp_object_id" {
  value = data.azuread_service_principal.aro_rp_app.object_id
}
# resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor_pre" {
#   scope                =  var.resource_group_id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.aro_rp_app.id
#   skip_service_principal_aad_check = true
# }

resource "azurerm_role_assignment" "aro_cluster_service_principal_network_contributor" {
  scope                            =  var.virtual_network_id
  role_definition_name             = "Contributor"
  principal_id                     = azuread_service_principal.aro_rp_app.id
  skip_service_principal_aad_check = true
}

resource "azurerm_role_assignment" "aro_resource_provider_service_principal_network_contributor" {
  scope                            = var.virtual_network_id
  role_definition_name             = "Contributor"
  principal_id                     = data.azuread_service_principal.aro_rp_app.object_id
  skip_service_principal_aad_check = true
}

*/

resource "azapi_resource" "aro_cluster" {
  name      = var.arocluster_name
  location  = var.location
  parent_id = var.resource_group_id
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
    tags = merge({
    Environment = var.environment
    BuildBy     = var.tag_buildby
    BuildTicket = var.tag_buildticket
    BuildDate   = var.tag_builddate
  }, var.global_tags)

    timeouts {
    create = "75m"
  }
  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = var.domain
        fipsValidatedModules = "Enabled"
        resourceGroupId      = local.resource_group_id
        pullSecret           = var.pull-secret
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
        vmSize = var.master_vmsize # Replace with your desired VM size
        # osDiskSizeGB          = 1024  # P10 disk size (1024 GB)
        subnetId         = var.master_subnet_id
        encryptionAtHost = var.master_encryption_at_host
      }
      workerProfiles = [
        {
          name             = var.worker_profile_name
          vmSize           = var.worker_node_vm_size
          diskSizeGB       = var.woker_node_diskSizeGB
          subnetId         = var.worker_subnet_id
          count            = var.worker_node_count
          encryptionAtHost = var.worker_encryption_at_host
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
  resource_id            = var.arocluster_id
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

