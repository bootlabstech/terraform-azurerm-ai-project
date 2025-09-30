data "azurerm_client_config" "current" {}
data "azurerm_key_vault" "example" {
  name                = var.keyvault_name
  resource_group_name = var.resource_group_name
}

# resource "azurerm_key_vault_access_policy" "test" {
#   key_vault_id = data.azurerm_key_vault.example.id
#   tenant_id    = data.azurerm_key_vault.example.tenant_id
#   object_id    = data.azurerm_client_config.current.object_id

#   key_permissions = [
#     "Create",
#     "Get",
#     "Delete",
#     "Purge",
#     "List",
#     "GetRotationPolicy",
#   ]
# }

resource "azurerm_ai_foundry" "ai_foundry" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_id        = data.azurerm_key_vault.example.id
  storage_account_id  = azurerm_storage_account.example.id

  depends_on = [azurerm_storage_account.example]
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "example" {
  name               = "${var.name}-project"
  location           = var.location
  ai_services_hub_id = azurerm_ai_foundry.ai_foundry.id

  depends_on = [azurerm_storage_account.example, azurerm_ai_foundry.ai_foundry]

  identity {
    type = "SystemAssigned"
  }
}

# SA
# Creates a Storage account
resource "azurerm_storage_account" "example" {
  name                            = "${var.name}-stg"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_kind                    = var.account_kind
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled
  min_tls_version                 = var.min_tls_version
  access_tier                     = var.access_tier
  public_network_access_enabled   = var.public_network_access_enabled

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}