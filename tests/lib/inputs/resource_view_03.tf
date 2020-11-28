provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "main" {
  name     = "main"
  location = "West Europe"
}

resource "azurerm_storage_account" "main" {
  name                     = "main"
  resource_group_name      = "${azurerm_resource_group.main.name}"
  location                 = "${azurerm_resource_group.main.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_monitor_log_profile" "main" {
  name               = "main"
  categories         = ["Action", "Delete", "Write"]
  locations          = ["global", "${azurerm_resource_group.main.location}"]
  storage_account_id = "${azurerm_storage_account.main.id}"

  retention_policy {
    enabled = false
  }
}
