output "resource_group" {
  value = azurerm_resource_group.rg.name
}

output "web_app_name" {
  value = azurerm_linux_web_app.web.name
}

output "web_app_url" {
  value = "https://${azurerm_linux_web_app.web.default_hostname}"
}

output "sql_server_fqdn" {
  value = "${azurerm_mssql_server.sql.name}.database.windows.net"
}

output "db_name" {
  value = azurerm_mssql_database.db.name
}

output "key_vault_name" {
  value = azurerm_key_vault.kv.name
}
