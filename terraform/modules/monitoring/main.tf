
locals {
  supported_retention_days = min(max(var.retention_days, 30), 730)
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "log-${var.name_prefix}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = local.supported_retention_days
  tags                = var.tags
}

# Container Insights solution (surfaces AKS container metrics/logs).
resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.log.id
  workspace_name        = azurerm_log_analytics_workspace.log.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}
