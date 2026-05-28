# modules/tfstate/main.tf

resource "azurerm_resource_group" "tfstate_rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "tfstate_sa" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.tfstate_rg.name
  location                        = azurerm_resource_group.tfstate_rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
  }

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.tfstate_sa.name
  container_access_type = "private"
}   