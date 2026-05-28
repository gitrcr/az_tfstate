resource "azurerm_storage_account" "tfstate_sa" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  blob_properties {
    versioning_enabled = true
    delete_retention_policy {
      days = 2
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "tfstate_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.tfstate_sa.id
  container_access_type = "private"
}