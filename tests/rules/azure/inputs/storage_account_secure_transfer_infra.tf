resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "validstorageaccount1" {
  name                     = "validstorageaccount1"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = true

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "invalidstorageaccount1" {
  name                     = "invalidstorageaccount1"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = false

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "invalidstorageaccount2" {
  name                     = "invalidstorageaccount2"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  enable_https_traffic_only = false

  tags = {
    environment = "staging"
  }
}