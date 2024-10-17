resource azurerm_storage_account main {
  name                     = "st${random_string.main.result}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource azurerm_storage_share minecraft {
  name                 = "minecraft"
  storage_account_name = azurerm_storage_account.main.name
  quota                = 50
}