resource "azurerm_route_table" "route_table" {
  name                          = var.routetable_name
  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  disable_bgp_route_propagation = var.disable_bgp

  dynamic "route" {
    for_each = var.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = var.tags
}

output "id" {
  value = azurerm_route_table.route_table.id
}