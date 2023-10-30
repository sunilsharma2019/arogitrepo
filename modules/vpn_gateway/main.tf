resource "azurerm_public_ip" "vpn_gw_ip" {
  name                = var.vpn_gw_ip
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "gateway" {
  name                = var.vpn_gw_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = var.vpn_gw_sku
  generation    = var.generation

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gw_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.vpn_subnet_id
  }

}
