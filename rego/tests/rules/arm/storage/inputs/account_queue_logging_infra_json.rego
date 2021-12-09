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
package tests.rules.arm.storage.inputs.account_queue_logging_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "resources": [
    {
      "apiVersion": "2021-04-01",
      "kind": "StorageV2",
      "location": "switzerlandnorth",
      "name": "regulalogstorage1",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2021-04-01",
      "kind": "StorageV2",
      "location": "switzerlandnorth",
      "name": "regulastorage1",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "Microsoft.Storage/storageAccounts/regulalogstorage1",
        "Microsoft.Storage/storageAccounts/regulastorage1"
      ],
      "name": "setting1",
      "properties": {
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulalogstorage1')]"
      },
      "scope": "Microsoft.Storage/storageAccounts/regulastorage1",
      "type": "Microsoft.Insights/diagnosticSettings"
    },
    {
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "Microsoft.Storage/storageAccounts/regulalogstorage1",
        "Microsoft.Storage/storageAccounts/regulastorage1"
      ],
      "name": "regulastorage1/default/Microsoft.Insights/setting1",
      "properties": {
        "logs": [
          {
            "category": "StorageRead",
            "enabled": true
          },
          {
            "category": "StorageWrite",
            "enabled": true
          },
          {
            "category": "StorageDelete",
            "enabled": false
          }
        ],
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulalogstorage1')]"
      },
      "type": "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticSettings"
    },
    {
      "apiVersion": "2021-04-01",
      "kind": "StorageV2",
      "location": "switzerlandnorth",
      "name": "regulalogstorage2",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2021-04-01",
      "kind": "StorageV2",
      "location": "switzerlandnorth",
      "name": "regulastorage2",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "Microsoft.Storage/storageAccounts/regulalogstorage2",
        "Microsoft.Storage/storageAccounts/regulastorage2"
      ],
      "name": "setting2",
      "properties": {
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulalogstorage2')]"
      },
      "scope": "Microsoft.Storage/storageAccounts/regulastorage2",
      "type": "Microsoft.Insights/diagnosticSettings"
    },
    {
      "apiVersion": "2017-05-01-preview",
      "dependsOn": [
        "Microsoft.Storage/storageAccounts/regulalogstorage2",
        "Microsoft.Storage/storageAccounts/regulastorage2"
      ],
      "name": "regulastorage2/default/Microsoft.Insights/setting2",
      "properties": {
        "logs": [
          {
            "category": "StorageRead",
            "enabled": true
          },
          {
            "category": "StorageWrite",
            "enabled": true
          },
          {
            "category": "StorageDelete",
            "enabled": true
          }
        ],
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulalogstorage2')]"
      },
      "type": "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticSettings"
    }
  ]
}

