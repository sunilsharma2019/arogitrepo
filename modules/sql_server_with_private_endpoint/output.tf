# Output the private endpoint connection name
output "private_endpoint_connection_name" {
  value = azurerm_private_endpoint.sql_pep.private_service_connection.0.name
}

# Output the private endpoint ID
output "private_endpoint_id" {
  value = azurerm_private_endpoint.sql_pep.id
}

# Output the SQL server name
output "sql_server_name" {
  value = azurerm_mssql_server.sql_server.name
}

# Output the SQL server ID
output "sql_server_id" {
  value = azurerm_mssql_server.sql_server.id
}