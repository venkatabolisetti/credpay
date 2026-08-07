locals {
  name_prefix = "credpays1"
  tags = {
    project     = "credpay"
    managed-by  = "terraform"
  }
}

module "resource-group" {
  source = "./modules/resource-group"
  resource_group_name = var.resource_group_name
  location = var.location
  tags = local.tags
}

module "networking" {
  source = "./modules/networking"
  name_prefix = local.name_prefix
  resource_group_name = module.resource-group.name
  location = module.resource-group.location
  tags = local.tags
  vnet_address_space = var.vnet_address_space
  aks_subnet_prefix = var.aks_subnet_prefix
  postgres_subnet_prefix = var.postgres_subnet_prefix
}

module "monitoring" {
  source = "./modules/monitoring"
  name_prefix = local.name_prefix
  resource_group_name = module.resource-group.name
  location = module.resource-group.location
  retention_days = var.log_retention_days
  tags = local.tags
}

module "postgres" {
  source = "./modules/postgres"
  name_prefix = local.name_prefix
  resource_group_name = module.resource-group.name
  location = module.resource-group.location
  tags = local.tags
  postgres_version = var.postgres_version
  admin_username = var.postgres_admin_username
  database_name = var.postgres_database_name
}

module "aks" {
  source = "./modules/aks"
  name_prefix = local.name_prefix
  resource_group_name = module.resource-group.name
  location = module.resource-group.location
  tags = local.tags
  aks_subnet_id = module.networking.subnet_ids["aks"]
  node_count = var.aks_node_count
  node_min_count = var.node_min_count
  node_max_count = var.node_max_count 
  vm_size = var.node_vm_size
  log_analytics_workspace_id = module.monitoring.workspace_id
  
}

module "key_vault" {
  source = "./modules/keyvault"
  key_vault_name = var.key_vault_name
  key_vault_resource_group_name = var.key_vault_resource_group_name
  postgres_admin_username = module.postgres.admin_username
  postgres_database_name = module.postgres.database_name
  postgres_admin_password = module.postgres.admin_password
  key_vault_location = module.resource-group.location
  postgres_host = module.postgres.fqdn
}