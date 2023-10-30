resource "azapi_resource" "symbolicname" {
  type = "Microsoft.RedHatOpenShift/openShiftClusters@2023-07-01-preview"
  name = "string"
  location = "string"
  parent_id = "string"
  tags = {
    tagName1 = "tagValue1"
    tagName2 = "tagValue2"
  }
  body = jsonencode({
    properties = {
      apiserverProfile = {
        ip = "string"
        url = "string"
        visibility = "string"
      }
      clusterProfile = {
        domain = "string"
        fipsValidatedModules = "string"
        pullSecret = "string"
        resourceGroupId = "string"
        version = "string"
      }
      consoleProfile = {
        url = "string"
      }
      ingressProfiles = [
        {
          ip = "string"
          name = "string"
          visibility = "string"
        }
      ]
      masterProfile = {
        diskEncryptionSetId = "string"
        encryptionAtHost = "string"
        subnetId = "string"
        vmSize = "string"
      }
      networkProfile = {
        loadBalancerProfile = {
          allocatedOutboundPorts = int
          managedOutboundIps = {
            count = int
          }
          outboundIpPrefixes = [
            {
              id = "string"
            }
          ]
          outboundIps = [
            {
              id = "string"
            }
          ]
        }
        outboundType = "string"
        podCidr = "string"
        serviceCidr = "string"
      }
      provisioningState = "string"
      servicePrincipalProfile = {
        clientId = "string"
        clientSecret = "string"
      }
      workerProfiles = [
        {
          count = int
          diskEncryptionSetId = "string"
          diskSizeGB = int
          encryptionAtHost = "string"
          name = "string"
          subnetId = "string"
          vmSize = "string"
        }
      ]
    }
  })
}