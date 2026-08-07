data "azurerm_key_vault" "kv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group_name
}

resource "azurerm_key_vault_secret" "postgres_host" {
  name         = "postgres-host"
  value        = var.postgres_host
  key_vault_id = data.azurerm_key_vault.kv.id
  
}

resource "azurerm_key_vault_secret" "postgres_username" {
  name         = "postgres-username"
  value        = var.postgres_admin_username
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "postgres_password" {
  name         = "postgres-password"
  value        = var.postgres_admin_password
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_key_vault_secret" "postgres_database" {
  name         = "postgres-database-name"
  value        = var.postgres_database_name
  key_vault_id = data.azurerm_key_vault.kv.id
}