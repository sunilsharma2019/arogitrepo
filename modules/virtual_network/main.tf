resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet.name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = var.vnet.address_space
  tags                = var.tags
}

