# Copyright 2020 Fugue, Inc.
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
package fugue.resource_view

import data.tests.lib.inputs.resource_view_03

test_resource_view_03 {
  resource_view_03.mock_resources == {
     "azurerm_monitor_log_profile.main": {
      "_type": "azurerm_monitor_log_profile",
      "categories": [
        "Action",
        "Delete",
        "Write"
      ],
      "id": "azurerm_monitor_log_profile.main",
      "locations": [
          "global",
          "westeurope"
      ],
      "name": "main",
      "retention_policy": [
        {
          "days": 0,
          "enabled": false
        }
      ],
      "servicebus_rule_id": null,
      "storage_account_id": "azurerm_storage_account.main",
      "timeouts": null
    },
    "azurerm_resource_group.main": {
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.main",
      "location": "westeurope",
      "name": "main",
      "tags": null,
      "timeouts": null
    },
    "azurerm_storage_account.main": {
      "_type": "azurerm_storage_account",
      "account_kind": "StorageV2",
      "account_replication_type": "GRS",
      "account_tier": "Standard",
      "allow_blob_public_access": false,
      "custom_domain": [],
      "enable_https_traffic_only": true,
      "id": "azurerm_storage_account.main",
      "is_hns_enabled": false,
      "location": "westeurope",
      "min_tls_version": "TLS1_0",
      "name": "main",
      "resource_group_name": "main",
      "static_website": [],
      "tags": null,
      "timeouts": null
    }
  }
}
