output "resource_group_name" {
  value = module.resource-group.name
}

output "vnet_id" {
  value = module.networking.vnet_id
}

output "aks_cluster_name" {
  value = module.aks.cluster_name
}

#output "aks_subnet_id" {
#  value = module.networking.aks_subnet_id
#}

output "aks_resource_group" {
  value = module.resource-group.name
}

output "aks_kubelet_identity_object_id" {
  description = "Object ID of the AKS kubelet (node) managed identity."
  value       = module.aks.kubelet_identity_object_id
}
output "aks_oidc_issuer_url" {
  description = "OIDC issuer URL (needed for workload identity federation)."
  value       = module.aks.oidc_issuer_url
}
output "aks_node_resource_group" {
  description = "Auto-generated node resource group (MC_...)."
  value       = module.aks.node_resource_group
}
output "get_credentials_command" {
  description = "Convenience command to fetch kubeconfig."
  value       = "az aks get-credentials --resource-group ${module.resource-group.name} --name ${module.aks.cluster_name} --overwrite-existing"
}

#output "postgres_server_name" {
#  value = module.postgres.name
#}
output "postgres_fqdn" {
  value = module.postgres.fqdn
}

output "postgres_database_name" {
  value = module.postgres.database_name
}
output "postgres_admin_username" {
  value = module.postgres.admin_username
}
output "postgres_admin_password" {
  value     = module.postgres.admin_password
  sensitive = true
}

output "log_analytics_workspace_id" {
  value = module.monitoring.workspace_id
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

