
resource "azurerm_public_ip" "web_lbpublicip" {
  name                = var.pip_name
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location
  allocation_method   = var.pip_allocation_method
  sku                 =  var.pip_sku
  tags = var.tags
}

resource "azurerm_lb" "web_lb" {
  name                      = var.loadbalancer_name
  location                  = var.resource_group.location
  resource_group_name       = var.resource_group.name
  sku                       = var.loadbalancer_sku

  frontend_ip_configuration {
    name                 = "web-lb-pip-1"
    public_ip_address_id = azurerm_public_ip.web_lbpublicip.id
  }
}

resource "azurerm_lb_backend_address_pool" "web_lb_backend_address_pool" {
  name                = var.web_lb_backend_pool_name
  loadbalancer_id     = azurerm_lb.web_lb.id
}

resource "azurerm_lb_probe" "web_lb_probe" {
  name                = "tcp-probe"
  protocol            = "Tcp"
  port                = 443
  loadbalancer_id     = azurerm_lb.web_lb.id
}

resource "azurerm_lb_rule" "web_lb_rule_app1" {
  name                              = "web-app1-rule"
  protocol                          = "Tcp"
  frontend_port                     = 443
  backend_port                      = 443
  frontend_ip_configuration_name    = azurerm_lb.web_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids          = [ azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id ]
  probe_id                          = azurerm_lb_probe.web_lb_probe.id
  loadbalancer_id                   = azurerm_lb.web_lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "web_nic_lb_associate" {
  network_interface_id    = var.web_vm_nic_id
  ip_configuration_name   = var.web_vm_nic_ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.web_lb_backend_address_pool.id
}