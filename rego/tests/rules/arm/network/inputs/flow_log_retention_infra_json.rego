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
package tests.rules.arm.network.inputs.flow_log_retention_infra_json

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
      "apiVersion": "2021-03-01",
      "location": "switzerlandnorth",
      "name": "RegulaNSG1",
      "type": "Microsoft.Network/networkSecurityGroups"
    },
    {
      "apiVersion": "2021-03-01",
      "location": "switzerlandnorth",
      "name": "RegulaNSG2",
      "type": "Microsoft.Network/networkSecurityGroups"
    },
    {
      "apiVersion": "2021-03-01",
      "location": "switzerlandnorth",
      "name": "RegulaNSG3",
      "type": "Microsoft.Network/networkSecurityGroups"
    },
    {
      "apiVersion": "2021-04-01",
      "kind": "StorageV2",
      "location": "switzerlandnorth",
      "name": "regulasa01",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2021-04-01",
      "location": "switzerlandnorth",
      "name": "RegulaWatcher1",
      "resources": [
        {
          "apiVersion": "2021-04-01",
          "dependsOn": [
            "Microsoft.Network/networkWatchers/RegulaWatcher1",
            "Microsoft.Storage/storageAccounts/regulasa01"
          ],
          "location": "switzerlandnorth",
          "name": "FL1",
          "properties": {
            "retentionPolicy": {
              "days": 90,
              "enabled": true
            },
            "storageId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulasa01')]",
            "targetResourceId": "[resourceId('Microsoft.Network/networkSecurityGroups', 'RegulaNSG1')]"
          },
          "type": "flowLogs"
        },
        {
          "apiVersion": "2021-04-01",
          "dependsOn": [
            "Microsoft.Network/networkWatchers/RegulaWatcher1",
            "Microsoft.Storage/storageAccounts/regulasa01"
          ],
          "location": "switzerlandnorth",
          "name": "FL2",
          "properties": {
            "retentionPolicy": {
              "days": 70,
              "enabled": true
            },
            "storageId": "[resourceId('Microsoft.Storage/storageAccounts', 'regulasa01')]",
            "targetResourceId": "[resourceId('Microsoft.Network/networkSecurityGroups', 'RegulaNSG2')]"
          },
          "type": "flowLogs"
        }
      ],
      "type": "Microsoft.Network/networkWatchers"
    }
  ]
}

