# dev/variables.tf

variable "location" {
  description = "Región de Azure"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "Nombre único de la cuenta de almacenamiento"
  type        = string
  # Ejemplo: "sttfstate001"
}

variable "container_name" {
  description = "Nombre del contenedor blob"
  type        = string
  default     = "tfstate"
}

variable "tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "State Storage"
  }
}

# Credenciales (se inyectan desde .tfvars o entorno)
variable "client_id" {
  type      = string
  sensitive = true
}
variable "client_secret" {
  type      = string
  sensitive = true
}
variable "subscription_id" {
  type      = string
  sensitive = true
}
variable "tenant_id" {
  type      = string
  sensitive = true
}   