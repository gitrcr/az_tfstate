module "resource_group_tfstate" {
  source              = "../../modules/resource_group"
  resource_group_name = "dev-tfstate-rg"
  location            = var.location
  tags                = var.tags
}

module "tfstate" {
  source = "../../modules/tfstate" # Ajusta la ruta según tu estructura real

  # NOMBRE EXPLÍCITO PARA EL RG DEDICADO
  resource_group_name  = module.resource_group_tfstate.name     # <-- Usa la SALIDA del módulo de RG
  location             = module.resource_group_tfstate.location # <-- Usa la ubicación del módulo de RG
  storage_account_name = var.storage_account_name
  container_name       = var.container_name
  tags                 = var.tags
}

module "resource_group" {
  source              = "../../modules/resource_group"
  resource_group_name = "dev-rg"
  location            = var.location
  tags                = var.tags
}
module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  vnet_name          = "dev-vnet"
  vnet_address_space = ["10.40.0.0/16"]
  tags               = var.tags
}