# Copyright 2020-2021 Fugue, Inc.
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
