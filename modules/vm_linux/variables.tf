variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "Object descibing the Resource group name and location we are deploying in."
}

variable "allot_pip" {
  type        = bool
  description = "Enable or Disable Public IP"
  default     = false
}

variable "vnet_subnet_id" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
}

variable "zones" {
  description = "A list of a single item of the Availability Zone which the Virtual Machine should be allocated in"
  type        = list(string)
  default     = ["1"]
}

#variable "key_vault_id" {
#  description = "key_vault_id where the virtual machines password will reside."
#  type        = string
#}

variable "network_security_group_id" {
  description = "network_security_group_id to associate with VM NIC"
  type        = string
}

variable "ssh_key" {
  description = "Path to the public key to be used for ssh access to the VM. Only used with non-Windows vms and can be left as-is even if using Windows vms. If specifying a path to a certification on a Windows machine to provision a linux vm use the / in the path versus backslash. e.g. c:/home/id_rsa.pub."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ssh_key_values" {
  description = "List of Public SSH Keys values to be used for ssh access to the VMs."
  type        = list(string)
  default     = []
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
  type        = string
  default     = "PFSQAAdmin"
}

variable "custom_data" {
  description = "The custom data to supply to the machine. This can be used as a cloud-init for Linux systems."
  type        = string
  default     = ""
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  type        = list(string)
  default     = ["Standard_D2s_v3"]
}

variable "nb_instances" {
  description = "Specify the number of vm instances."
  type        = number
  default     = 1
}

variable "vm_hostname" {
  description = "local name of the Virtual Machine."
  type        = string
}

variable "vm_os_publisher" {
  description = "The name of the publisher of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_offer" {
  description = "The name of the offer of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_sku" {
  description = "The sku of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = ""
}

variable "vm_os_version" {
  description = "The version of the image that you want to deploy. This is ignored when vm_os_id or vm_os_simple are provided."
  type        = string
  default     = "latest"
}

variable "tags" {
  type        = map(string)
  description = "A map of the tags to use on the resources that are deployed with this module."

  default = {
    Source       = "terraform"
    Environment  = "QAS"
    Company      = "PFS"
  }
}

variable "allocation_method" {
  description = "Defines how an IP address is assigned. Options are Static or Dynamic."
  type        = string
  default     = "Dynamic"
}

variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Delete datadisk when machine is terminated."
  default     = false
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Delete data disks when machine is terminated."
  default     = false
}

variable "data_sa_type" {
  description = "Data Disk Storage Account type."
  type        = string
  default     = "Standard_LRS"
}

variable "os_sa_type" {
  description = "OS Disk Storage Account type."
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "Storage data disk size size."
  type        = number
  default     = 30
}

variable "data_disk_size_gb" {
  description = "Storage data disk size size."
  type        = number
  default     = 128
}

variable "enable_accelerated_networking" {
  type        = bool
  description = "(Optional) Enable accelerated networking on Network interface."
  default     = false
}

variable "enable_ssh_key" {
  type        = bool
  description = "(Optional) Enable ssh key authentication in Linux virtual Machine."
  default     = true
}

variable "nb_data_disk" {
  description = "(Optional) Number of the data disks attached to each virtual machine."
  type        = number
  default     = 0
}

variable "extra_disks" {
  description = "(Optional) List of extra data disks attached to each virtual machine."
  type = list(object({
    name = string
    size = number
  }))
  default = []
}

variable "boot_diagnostics" {
  type        = bool
  description = "(Optional) Enable or Disable boot diagnostics."
  default     = true
}

variable "recovery_vault_name" {
  type        = string
}

variable "backup_policy_id" {
  type        = string
}

variable "rsv_resource_group_name" {
  type        = string
}

variable "loganalytics_id" {
  type = list(string)
}

variable "enable_diagnostic" {
  type = bool
}