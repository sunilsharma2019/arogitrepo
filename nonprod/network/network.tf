########################### Virtual Network and Subnet ##########################

module "vnet" {
  source = "../../modules/virtual_network"
  resource_group = {
    name     = var.rg1.name
    location = var.rg1.location
  }
  vnet = var.vnet01
  tags = var.global_tags
}

module "subnets" {
  source = "../../modules/subnet"
  resource_group = {
    name     = var.rg1.name
    location = var.rg1.location
  }
  vnet_name = module.vnet.vnet.name
  subnets   = var.subnets
}