output "vnet_id" {
  description = "Virtual network resource ID."
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "Virtual network name."
  value       = azurerm_virtual_network.vnet.name
}

output "subnet_ids" {
  description = "Map of subnet name -> subnet ID."
  value = {
    aks      = azurerm_subnet.aks_subnet.id
    postgres = azurerm_subnet.postgres_subnet.id
  }
}
