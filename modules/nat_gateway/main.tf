resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.nat_gw_name
  location                = var.resource_group.location
  resource_group_name     = var.resource_group.name
}

resource "azurerm_public_ip" "nat_public_ip" {
  name                = var.nat_pub_ip_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.pip_sku
  allocation_method   = "Static"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip_attach" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = azurerm_public_ip.nat_public_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "nat_sb_attach" {
  count          = length(var.nat_attach_subnet)
  subnet_id      = var.nat_attach_subnet[count.index]
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

