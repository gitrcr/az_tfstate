resource "azurerm_virtual_network" "vnet" {
  location            = var.location
  resource_group_name = var.resource_group_name

  name          = var.vnet_name
  address_space = var.vnet_address_space
  tags          = var.tags

}

