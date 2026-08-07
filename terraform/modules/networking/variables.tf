variable "name_prefix" {
  description = "Prefix for resource names."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network."
  type        = string
}

variable "aks_subnet_prefix" {
  description = "Subnet prefix for the AKS cluster."
  type        = string
}

variable "postgres_subnet_prefix" {
  description = "Subnet prefix for the PostgreSQL server."
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources."
  type        = map(string)
  default     = {}
}

