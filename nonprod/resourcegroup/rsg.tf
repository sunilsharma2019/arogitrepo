############### Resource Group Deployment Code ###############

module "rsg" {
  source = "../../modules/resource_group_rg"

  resource_group = var.rg1
  tags           = var.global_tags
}