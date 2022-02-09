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
package tests.rules.tf.azurerm.storage.inputs.container_private_access_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_resource_group.example": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/container_private_access_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.example",
      "location": "West Europe",
      "name": "example-resources"
    },
    "azurerm_storage_account.example": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/container_private_access_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "LRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.example",
      "location": "West Europe",
      "name": "examplestoraccount",
      "resource_group_name": "example-resources",
      "tags": {
        "environment": "staging"
      }
    },
    "azurerm_storage_container.invalidcontainer1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/container_private_access_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_container",
      "container_access_type": "container",
      "id": "azurerm_storage_container.invalidcontainer1",
      "name": "invalidcontainer1",
      "storage_account_name": "examplestoraccount"
    },
    "azurerm_storage_container.validcontainer1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/container_private_access_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_container",
      "container_access_type": "private",
      "id": "azurerm_storage_container.validcontainer1",
      "name": "validcontainer1",
      "storage_account_name": "examplestoraccount"
    }
  }
}

