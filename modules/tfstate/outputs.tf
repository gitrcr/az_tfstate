# modules/storage-backend/outputs.tf

output "resource_group_name" {
  description = "Nombre del Resource Group"
  value       = var.resource_group_name
}

output "storage_account_name" {
  description = "Nombre de la cuenta de almacenamiento"
  value       = var.storage_account_name
}

output "container_name" {
  description = "Nombre del contenedor"
  value       = var.container_name
}

output "storage_account_id" {
  description = "ID completo de la cuenta de almacenamiento"
  value       = azurerm_storage_account.tfstate_sa.id
}   