############################### Virtual Netowrk and Subnet #####################

variable "vnet01" {
  type = object({
    name          = string
    address_space = list(string)
  })
}

variable "subnets" {
  type = list(object({
    name                      = string
    subnet_prefix             = list(string)
    endpoint_network_policies = bool
    service_network_policies  = bool
    service_delegation        = bool
    service_delegation_name   = string
    service_delegation_action = list(string) 
  }))
}

############################# Global Tags #################################

variable "global_tags" {
  type        = map(any)
  description = "(Optional) A map of tags to be applied globally on all Azure resources"
  default     = {}
}

############ Resource Group variables ################
variable "rg1" {
  type = object({
    name     = string
    location = string
  })
}

# ############# Service Endpoints  ##############

# variable "service_endpoints" {
#   type			= list
#   description 		= ""
#   default 		= [
#     "Microsoft.ContainerRegistry",
#     "Microsoft.KeyVault",
#     "Microsoft.Storage"
#   ]
# }