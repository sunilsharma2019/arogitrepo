variable "env" {
  type    = string
  default = "poc"
}

variable "location" {
  type    = string
  default = "uksouth"
}

############ Resource Group variables ################
variable "rg1" {
  type = object({
    name     = string
    location = string
  })
}

# variable "rg2" {
#   type = object({
#     name     = string
#     location = string
#   })
# }

# variable "rg3" {
#   type = object({
#     name     = string
#     location = string
#   })
# }

# variable "rg4" {
#   type = object({
#     name     = string
#     location = string
#   })
# }

# variable "rg5" {
#   type = object({
#     name     = string
#     location = string
#   })
# }

# variable "rg6" {
#   type = object({
#     name     = string
#     location = string
#   })
# }

############################# Global Tags #################################

variable "global_tags" {
  type        = map(any)
  description = "(Optional) A map of tags to be applied globally on all Azure resources"
  default     = {}
}