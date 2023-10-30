
resource "azurerm_subnet" "subnet" {
  count                                          = length (var.subnets)
  resource_group_name                            = var.resource_group.name
  name                                           = var.subnets[count.index].name
  address_prefixes                               = var.subnets[count.index].subnet_prefix
  virtual_network_name                           = var.vnet_name
#  enforce_private_link_endpoint_network_policies = var.subnet.enforce_private_link
  service_endpoints                              = var.service_endpoints
}
