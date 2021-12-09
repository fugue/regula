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
package tests.rules.arm.key_vault.inputs.secret_expiry_infra_json

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
      "apiVersion": "2021-06-01-preview",
      "location": "[resourceGroup().location]",
      "name": "regulasecretvault1",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[subscription().subscriptionId]",
            "permissions": {
              "certificates": [],
              "keys": [],
              "secrets": [
                "Get",
                "List"
              ]
            },
            "tenantId": "[subscription().tenantId]"
          }
        ],
        "enablePurgeProtection": true,
        "enabledForDiskEncryption": true,
        "sku": {
          "family": "A",
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "resources": [
        {
          "apiVersion": "2021-06-01-preview",
          "dependsOn": [
            "Microsoft.KeyVault/vaults/regulasecretvault1"
          ],
          "name": "secret1",
          "properties": {
            "value": "hunter2"
          },
          "type": "secrets"
        },
        {
          "apiVersion": "2021-06-01-preview",
          "dependsOn": [
            "Microsoft.KeyVault/vaults/regulasecretvault1"
          ],
          "name": "secret2",
          "properties": {
            "attributes": {
              "exp": 1700000000
            },
            "value": "hunter2"
          },
          "type": "secrets"
        }
      ],
      "type": "Microsoft.KeyVault/vaults"
    }
  ]
}

