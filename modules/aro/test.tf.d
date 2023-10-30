
resource "azapi_resource" "aro_cluster" {
  name      = "aroeandmoney"
  location  = "East US"
  parent_id = "rg-eandmoney-NonProd-01"
  type      = "Microsoft.RedHatOpenShift/openShiftClusters@2022-04-01"
  #   tags = merge({
  #   Environment = var.environment
  #   BuildBy     = var.tag_buildby
  #   BuildTicket = var.tag_buildticket
  #   BuildDate   = var.tag_builddate
  # }, var.global_tags)

    timeouts {
    create = "75m"
  }
  body = jsonencode({
    properties = {
      clusterProfile = {
        domain               = "eandmoney"
        fipsValidatedModules = "Enabled"
        resourceGroupId      = "rg-eandmoney-NonProd-01"
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
