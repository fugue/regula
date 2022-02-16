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
package tests.rules.tf.azurerm.storage.inputs.network_access_trust_microsoft_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_resource_group.rg1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.rg1",
      "location": "Central US",
      "name": "random_string.seed-rg1"
    },
    "azurerm_storage_account.invalid1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.invalid1",
      "location": "Central US",
      "name": "random_string.seedinvalid1",
      "resource_group_name": "random_string.seed-rg1"
    },
    "azurerm_storage_account.invalid2": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.invalid2",
      "location": "Central US",
      "name": "random_string.seedinvalid2",
      "resource_group_name": "random_string.seed-rg1"
    },
    "azurerm_storage_account.valid1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.valid1",
      "location": "Central US",
      "name": "random_string.seedvalid1",
      "resource_group_name": "random_string.seed-rg1"
    },
    "azurerm_storage_account.valid2": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.valid2",
      "location": "Central US",
      "name": "random_string.seedvalid2",
      "resource_group_name": "random_string.seed-rg1"
    },
    "azurerm_storage_account.valid3": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "id": "azurerm_storage_account.valid3",
      "location": "Central US",
      "name": "random_string.seedvalid3",
      "resource_group_name": "random_string.seed-rg1"
    },
    "azurerm_storage_account_network_rules.invalidrule1": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account_network_rules",
      "bypass": [
        "Logging"
      ],
      "default_action": "Deny",
      "id": "azurerm_storage_account_network_rules.invalidrule1",
      "resource_group_name": "random_string.seed-rg1",
      "storage_account_name": "random_string.seedinvalid1"
    },
    "azurerm_storage_account_network_rules.invalidrule2": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account_network_rules",
      "bypass": [
        "Logging",
        "Metrics"
      ],
      "default_action": "Deny",
      "id": "azurerm_storage_account_network_rules.invalidrule2",
      "resource_group_name": "random_string.seed-rg1",
      "storage_account_name": "random_string.seedinvalid2"
    },
    "azurerm_storage_account_network_rules.validrule2": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account_network_rules",
      "bypass": [
        "AzureServices"
      ],
      "default_action": "Allow",
      "id": "azurerm_storage_account_network_rules.validrule2",
      "resource_group_name": "random_string.seed-rg1",
      "storage_account_name": "random_string.seedvalid2"
    },
    "azurerm_storage_account_network_rules.validrule3": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "azurerm_storage_account_network_rules",
      "bypass": [
        "AzureServices",
        "Logging",
        "Metrics"
      ],
      "default_action": "Deny",
      "id": "azurerm_storage_account_network_rules.validrule3",
      "resource_group_name": "random_string.seed-rg1",
      "storage_account_name": "random_string.seedvalid3"
    },
    "data.azurerm_client_config.current": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "azurerm",
      "_type": "data.azurerm_client_config",
      "id": "data.azurerm_client_config.current"
    },
    "random_string.seed": {
      "_filepath": "tests/rules/tf/azurerm/storage/inputs/network_access_trust_microsoft.tf",
      "_provider": "random",
      "_type": "random_string",
      "id": "random_string.seed",
      "length": 8,
      "number": false,
      "special": false,
      "upper": false
    }
  }
}

