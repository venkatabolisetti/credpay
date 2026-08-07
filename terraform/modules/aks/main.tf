resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.name_prefix
  node_resource_group = "rg-${var.name_prefix}-aks-nodes"

  #node_provisioning_profile {} 
  
 
  #automatic_upgrade_channel = "stable"
  #node_os_upgrade_channel = "NodeImage"
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled = true
    tenant_id          = "997d0847-68e6-481c-b906-8025d95852e0"
  }

  default_node_pool {
    name       = "system"
    node_count = var.node_count
    vm_size    = var.vm_size
    #auto_scaling_enabled = true
    min_count = 0
    max_count = var.node_max_count
    vnet_subnet_id = var.aks_subnet_id
    os_sku = "Ubuntu"
    max_pods = 60
    type = "VirtualMachineScaleSets"
    upgrade_settings {
      max_surge = "33%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    outbound_type = "loadBalancer"
    network_policy = "azure"
    service_cidr = "10.240.0.0/16"
    dns_service_ip = "10.240.0.10"
  }

 oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  tags = var.tags


lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count ]
  }
}
