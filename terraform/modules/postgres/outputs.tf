output "server_id" {
  description = "PostgreSQL Flexible Server resource ID."
  value       = azurerm_postgresql_flexible_server.postgres.id
}

output "server_name" {
  description = "PostgreSQL Flexible Server name."
  value       = azurerm_postgresql_flexible_server.postgres.name
}

output "fqdn" {
  description = "Public FQDN of the server (Phase 1 public access)."
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "database_name" {
  description = "Application database name."
  value       = azurerm_postgresql_flexible_server_database.credpaydb.name
}

output "admin_username" {
  description = "Administrator username."
  value       = azurerm_postgresql_flexible_server.postgres.administrator_login
}

output "admin_password" {
  description = "Generated administrator password."
  value       = random_password.admin.result
  sensitive   = true
}
