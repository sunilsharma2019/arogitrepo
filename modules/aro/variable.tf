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

# variable "masterencryption" {
#   description = "encryptionAtHost for master node."
#   default = "Disabled"
# }

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

# variable "workerencryption" {
#   description = "encryptionAtHost for worker node."
#   default = "Disabled"
# }

variable "master_subnet_id" {
  description = "Master Subnet ID."
}

variable "worker_subnet_id" {
  description = "Master Subnet ID."
}

variable "master_encryption_at_host" {
  description = "Specifies whether master virtual machines are encrypted at host."
  default  = "Disabled" 
  validation {
    condition = contains(["Disabled", "Enabled"], var.master_encryption_at_host)
    error_message = "The value of the master_encryption_at_host parameter is invalid."
  }
}

variable "worker_encryption_at_host" {
  description = "Specifies whether master virtual machines are encrypted at host."
  default  = "Disabled" 
  validation {
    condition = contains(["Disabled", "Enabled"], var.worker_encryption_at_host)
    error_message = "The value of the worker_encryption_at_host parameter is invalid."
  }
}
#################   RedHat Console Secret  ###########################
variable "pull-secret" {
  description = "RedHat Console Pull Secret."
}

######################### Resouce Group of ARO ########################
variable "resource_group_id" {
  description = "Resource Group ID where ARO resources will deployed."
}

######################### ARO Cluster ID #################################
variable "arocluster_id" {
  description = "ARO Cluster ID where ARO resources will deployed."
}

######################### Virtual Network where ARO will be deployed #######

variable "virtual_network_id" {
  description = "Virtual Network ID where ARO resources will deployed."
}

############### api server and ingress ######################################

variable "api_server_visibility" {
  description = "api_server_visibility"
  default = "Public"
}
variable "ingress_profile_name" {
  description = "ingress_profile_name"
  default = "default"
}

variable "ingress_visibility" {
    description = "ingress_visibility"
  default = "Public"
}


