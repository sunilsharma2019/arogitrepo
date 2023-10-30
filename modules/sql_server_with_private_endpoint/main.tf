# Create a SQL server with private endpoint enabled
resource "azurerm_mssql_server" "sql_server" {
  name                         = var.sql_server_name
  location                     = var.resource_group.location
  resource_group_name          = var.resource_group.name
  version                      = "12.0"
  minimum_tls_version          = "1.2"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  # Enable private endpoint and set the private DNS zone
  identity { 
    type = "SystemAssigned"
  }  
  
  public_network_access_enabled = var.public_network_access_enabled
  #private_dns_zone_arm_resource_id = azurerm_private_dns_zone.sql_pep_dns_zone.id
}

# Create a network interface for the private endpoint
resource "azurerm_network_interface" "sql_pep_nic" {
  name                = var.sql_pep_nic_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "${var.sql_server_name}-ip-config"
    subnet_id                     = var.pep_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a private endpoint for the SQL server
resource "azurerm_private_endpoint" "sql_pep" {
  name                = var.sql_pep_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  subnet_id           = var.pep_subnet_id

  # Configure the private DNS zone and the SQL server resource
  private_service_connection {
    name                           = var.sql_pep_connection_name
    private_connection_resource_id = azurerm_mssql_server.sql_server.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

    private_dns_zone_group {
    name                 = "sql-dns-zone-group"
    private_dns_zone_ids = [var.sql_pep_dns_zone_id]

  }
}