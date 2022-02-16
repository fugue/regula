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
package tests.rules.tf.azurerm.storage.inputs.account_secure_transfer_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_resource_group.example": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/account_secure_transfer_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.example",
      "location": "West Europe",
      "name": "example-resources"
    },
    "azurerm_storage_account.invalidstorageaccount1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/account_secure_transfer_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "enable_https_traffic_only": false,
      "id": "azurerm_storage_account.invalidstorageaccount1",
      "location": "West Europe",
      "name": "invalidstorageaccount1",
      "resource_group_name": "example-resources",
      "tags": {
        "environment": "staging"
      }
    },
    "azurerm_storage_account.invalidstorageaccount2": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/account_secure_transfer_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "enable_https_traffic_only": false,
      "id": "azurerm_storage_account.invalidstorageaccount2",
      "location": "West Europe",
      "name": "invalidstorageaccount2",
      "resource_group_name": "example-resources",
      "tags": {
        "environment": "staging"
      }
    },
    "azurerm_storage_account.validstorageaccount1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/account_secure_transfer_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "enable_https_traffic_only": true,
      "id": "azurerm_storage_account.validstorageaccount1",
      "location": "West Europe",
      "name": "validstorageaccount1",
      "resource_group_name": "example-resources",
      "tags": {
        "environment": "staging"
      }
    }
  }
}

