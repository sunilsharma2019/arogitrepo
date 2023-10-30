################## ARO Cluster Domain Name #####################################################

variable "domain" {
  description = "The Azure Red Hat OpenShift (ARO) Domain Name"
}

variable "location" {
  description = "The location where all Azure Red Hat OpenShift resources should be created"
}

########### ARO service Priniciple  ##############################################################
# variable "aro_rp_app" {
#    description = "Azure AD application service principle should be created"
# }

variable "arocluster_name" {
  description = "Name of the ARO cluster to be created."
}

########## Tags ###################################################################################

variable "environment" {
  description = "Production, Development, etc"
}

variable "tag_buildby" {
  description = "Racker that built the resource."
}

variable "tag_buildticket" {
  description = "Build ticket number."
}

variable "tag_builddate" {
  description = "Date in ISO-8601 format (yyyymmdd)."
}

variable "global_tags" {
  description = "Additional tags to add to the resource."
  type        = map(string)
  default     = {}
}

############## POD and Service CIDR Ranges ######################################
variable "pod_cidr" {
  description = "POD CIDR ranges."
}

variable "service_cidr" {
  description = "Service CIDR ranges."
}

############## Master and Worker Nodes Configuration #############################

variable "master_vmsize" {
  description = "Master Node VM size."
}

variable "masterencryption" {
  description = "encryptionAtHost for master node."
  default     = "Disabled"
}

variable "worker_profile_name" {
  description = "Worker Node name"
}

variable "worker_node_vm_size" {
  description = "Worker Node VM size."
}

variable "woker_node_diskSizeGB" {
  description = "Worker Node VM disk size in GB."
}

variable "worker_node_count" {
  description = "Worker Node VM counts."
}

variable "workerencryption" {
  description = "encryptionAtHost for worker node."
  default     = "Disabled"
}

# variable "master_subnet_id" {
#   description = "Master Subnet ID."
# }

# variable "worker_subnet_id" {
#   description = "Master Subnet ID."
# }


# #################   RedHat Console Secret  ###########################
# variable "pull-secret" {
#   description = "RedHat Console Pull Secret."
# }

# ######################### Resouce Group of ARO ########################
# variable "resource_group_id" {
#   description = "Resource Group ID where ARO resources will deployed."
# }

# ######################### ARO Cluster ID #################################
# variable "arocluster_id" {
#   description = "ARO Cluster ID where ARO resources will deployed."
# }

# ######################### Virtual Network where ARO will be deployed #######

# variable "virtual_network_id" {
#   description = "Virtual Network ID where ARO resources will deployed."
# }

############### api server and ingress ######################################

variable "api_server_visibility" {
  description = "api_server_visibility"
  default     = "Public"
}
variable "ingress_profile_name" {
  description = "ingress_profile_name"
  default     = "default"
}

variable "ingress_visibility" {
  description = "ingress_visibility"
  default     = "Public"
}









/*

# variable "subscription" {}

variable "domain" {
  description = "The Azure Red Hat OpenShift (ARO) Domain Name"
}

variable "resource_prefix" {
  description = "Name of resource_prefix to decide the name."
}

variable "location" {
  description = "The location where all Azure Red Hat OpenShift resources should be created"
}

variable "virtual_network_address_space" {
  description = "Address space for virtual network"

}

variable "netrg" {
  description = "Resource Group for networking related resources"

}

variable "master_subnet_name" {
  description = "Subnet name for master node"
}


variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default = {
    BuildBy     = "Rackspace"
    Environment = "emoney-hub"
  }
}

############################# Global Tags #################################

variable "global_tags" {
  type        = map(any)
  description = "(Optional) A map of tags to be applied globally on all Azure resources"
  default     = {}
}
# variable "aadTenantId" {
#   description = "The Application ID used by the Azure Red Hat OpenShift"
# }

# variable "aro_cluster_aad_sp_client_id" {
#   description = "The Application ID used by the Azure Red Hat OpenShift"
# }

# variable "aro_cluster_aad_sp_client_secret" {
#   description = "The Application Secret used by the Azure Red Hat OpenShift"
# }

# variable "aadCustomerAdminGroupId" {
#   description = "The Adminstrators Group ID"
# }

variable "worker_subnet_name" {
  description = "The CIDR assigned to the ARO Worker Subnet"
}

# variable "clusterVnetIPRange" {
#   description = "The CIDR assigned to the ARO VNET"
# }

variable "master_subnet_address_space" {
  description = "The CIDR assigned to the ARO Subnet"
}

variable "worker_subnet_address_space" {
  description = "The CIDR assigned to the ARO Subnet"
}
variable "vnet_name" {
  description = "The Name of the peering VNET Name"
}

# variable "aro_cluster_aad_sp_object_id" {
#   description = "Service Principle id for aro cluster"
# }
# variable "peerVnetId" {
#   description = "The Name of the peering VNET ID"
# }

# variable "peerVnet_resource_group_name" {
#   description = "The Resource Group of the peering VNET"
# }

# variable "pull-secret" {
#   type = string
#   default = data.azurerm_key_vault_secret.pull-secret.value
# }

variable "master_node_vm_size" {

}

variable "clusterName" {
  description = "Cluster Name"
}

variable "worker_profile_name" {
  description = "Worker Name"

}

variable "master_profile_name" {
  description = "Master Name"

}

variable "worker_node_vm_size" {
  description = "Worker node vm size"
}
variable "worker_node_vm_disk_size" {
  description = "worker_node_vm_disk_size"
}

variable "api_server_visibility" {
  description = "Visibility of the ARO API server (public or private)."
  type        = string
  default     = "public"
}

variable "ingress_profile_name" {
  description = "Name of the ingress profile for services."
  type        = string
}

variable "ingress_visibility" {
  description = "Visibility of ingress profiles (public or private)."
  type        = string
  default     = "public"
}

variable "pod_cidr" {

}

variable "service_cidr" {

}

# variable "peerVnetId" {

# }

# variable "aro_rp_aad_sp_object_id" {

# }

variable "guid" {
  type    = string
  default = "ztpcw"
}

*/