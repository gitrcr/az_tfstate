module "resource_group" {
  source = "../../modules/resource_group"

  resource_group_name = "dev-rg"
  location            = "eastus"
  tags = {
    environment = "developement"
    project     = "freetier"
  }
}

module "network" {
  source = "../../modules/network"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  vnet_name          = "dev-vnet"
  vnet_address_space = ["10.40.0.0/16"]
  tags = {
    environment = "developement"
    project     = "freetier"
  }
}
