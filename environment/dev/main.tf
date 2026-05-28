# dev/main.tf

module "resource_group" {
  source              = "../../modules/resource_group"
  resource_group_name = "dev-rg"
  location            = var.location
  tags                = var.tags
}

# 1. Invocación al módulo EXISTENTE de Resource Group
# Crea el RG dedicado para aislar el estado
module "resource_group_tfstate" {
  source              = "../../modules/resource_group"
  resource_group_name = "dev-tfstate-rg"
  location            = var.location
  tags                = var.tags
}

# 2. Invocación al módulo de Storage (asumiendo que existe o creando uno simple)
# Si no tienes un módulo de storage separado, puedes usar el recurso directo aquí,
# pero lo ideal es que también haya un módulo. Usaremos recurso directo si no existe módulo.




module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  vnet_name          = "dev-vnet"
  vnet_address_space = ["10.40.0.0/16"]
  tags               = var.tags
}


resource "azurerm_storage_account" "tfstate_sa" {
  name                            = var.storage_account_name
  resource_group_name             = module.resource_group_tfstate.name     # <-- Usa la SALIDA del módulo de RG
  location                        = module.resource_group_tfstate.location # <-- Usa la ubicación del módulo de RG
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 30
    }
  }
  tags = var.tags
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate_sa.id
  container_access_type = "private"
}