resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoraccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "validcontainer1" {
  name                  = "validcontainer1"
  resource_group_name   = azurerm_resource_group.example.name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "validcontainer2" {
  name                  = "validcontainer2"
  resource_group_name   = azurerm_resource_group.example.name
  storage_account_name  = azurerm_storage_account.example.name
}

resource "azurerm_storage_container" "invalidcontainer1" {
  name                  = "invalidcontainer1"
  resource_group_name   = azurerm_resource_group.example.name
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "container"
}