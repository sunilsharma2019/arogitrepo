resource "azurerm_subnet_route_table_association" "rtb_snet_association" {
  subnet_id      = var.subnet_id
  route_table_id = var.route_table_id
#  depends_on     = ["azurerm_route_table.route_table"]
}