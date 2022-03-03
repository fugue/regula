# Copyright 2020-2022 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
provider "azurerm" {
  features {
  }
}

data "azurerm_client_config" "current" {}

resource "random_string" "seed" {
  length = 8
  special = false
  number = false
  upper = false
}

resource "azurerm_resource_group" "rg1" {
  name     = "${random_string.seed.result}-rg1"
  location = "Central US"
}

# The default network rules for a storage account trusts microsoft
# The network rules for this resource was manually added
resource "azurerm_storage_account" "valid1" {
  name                     = "${random_string.seed.result}valid1"
  resource_group_name      = "${azurerm_resource_group.rg1.name}"
  location                 = "${azurerm_resource_group.rg1.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account" "valid2" {
  name                     = "${random_string.seed.result}valid2"
  resource_group_name      = "${azurerm_resource_group.rg1.name}"
  location                 = "${azurerm_resource_group.rg1.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account_network_rules" "validrule2" {
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  storage_account_name = "${azurerm_storage_account.valid2.name}"

  default_action = "Allow"
  bypass         = ["AzureServices"]
}

resource "azurerm_storage_account" "valid3" {
  name                     = "${random_string.seed.result}valid3"
  resource_group_name      = "${azurerm_resource_group.rg1.name}"
  location                 = "${azurerm_resource_group.rg1.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account_network_rules" "validrule3" {
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  storage_account_name = "${azurerm_storage_account.valid3.name}"

  default_action = "Deny"
  bypass         = ["AzureServices", "Logging", "Metrics"]
}

resource "azurerm_storage_account" "invalid1" {
  name                     = "${random_string.seed.result}invalid1"
  resource_group_name      = "${azurerm_resource_group.rg1.name}"
  location                 = "${azurerm_resource_group.rg1.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account_network_rules" "invalidrule1" {
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  storage_account_name = "${azurerm_storage_account.invalid1.name}"

  default_action = "Deny"
  bypass         = ["Logging"]
}

resource "azurerm_storage_account" "invalid2" {
  name                     = "${random_string.seed.result}invalid2"
  resource_group_name      = "${azurerm_resource_group.rg1.name}"
  location                 = "${azurerm_resource_group.rg1.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_storage_account_network_rules" "invalidrule2" {
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  storage_account_name = "${azurerm_storage_account.invalid2.name}"

  default_action = "Deny"
  bypass         = [ "Logging", "Metrics" ]
}
