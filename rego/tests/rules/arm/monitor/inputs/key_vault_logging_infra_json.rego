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
package tests.rules.arm.monitor.inputs.key_vault_logging_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "vmName": {
      "metadata": {
        "description": "Name of the virtual machine."
      },
      "type": "string"
    }
  },
  "resources": [
    {
      "apiVersion": "2021-06-01",
      "kind": "StorageV2",
      "location": "[resourceGroup().location]",
      "name": "[variables('storageAccountName')]",
      "sku": {
        "name": "Standard_LRS"
      },
      "type": "Microsoft.Storage/storageAccounts"
    },
    {
      "apiVersion": "2021-04-01-preview",
      "location": "[resourceGroup().location]",
      "name": "valid",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[reference(resourceId('Microsoft.Compute/virtualMachines/', parameters('vmName')), '2020-12-01', 'full').identity.principalId]",
            "permissions": {
              "secrets": [
                "get"
              ]
            },
            "tenantId": "[subscription().tenantId]"
          }
        ],
        "sku": {
          "family": "A",
          "name": "standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-05-01-preview",
      "dependsOn": [
        "[resourceId('Microsoft.KeyVault/vaults', 'valid')]",
        "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
      ],
      "name": "valid",
      "properties": {
        "logs": [
          {
            "category": "AuditEvent",
            "enabled": true,
            "retentionPolicy": {
              "days": 180,
              "enabled": true
            }
          }
        ],
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
      },
      "scope": "[format('Microsoft.KeyVault/vaults/{0}', 'valid')]",
      "type": "Microsoft.Insights/diagnosticSettings"
    },
    {
      "apiVersion": "2021-04-01-preview",
      "location": "[resourceGroup().location]",
      "name": "invalidNoRetention",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[reference(resourceId('Microsoft.Compute/virtualMachines/', parameters('vmName')), '2020-12-01', 'full').identity.principalId]",
            "permissions": {
              "secrets": [
                "get"
              ]
            },
            "tenantId": "[subscription().tenantId]"
          }
        ],
        "sku": {
          "family": "A",
          "name": "standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-05-01-preview",
      "dependsOn": [
        "[resourceId('Microsoft.KeyVault/vaults', 'invalidNoRetention')]",
        "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
      ],
      "name": "invalidNoRetention",
      "properties": {
        "logs": [
          {
            "category": "AuditEvent",
            "enabled": true,
            "retentionPolicy": {
              "enabled": false
            }
          }
        ],
        "storageAccountId": "[resourceId('Microsoft.Storage/storageAccounts', variables('storageAccountName'))]"
      },
      "scope": "[format('Microsoft.KeyVault/vaults/{0}', 'invalidNoRetention')]",
      "type": "Microsoft.Insights/diagnosticSettings"
    },
    {
      "apiVersion": "2021-04-01-preview",
      "location": "[resourceGroup().location]",
      "name": "invalidNoDiagnostics",
      "properties": {
        "accessPolicies": [
          {
            "objectId": "[reference(resourceId('Microsoft.Compute/virtualMachines/', parameters('vmName')), '2020-12-01', 'full').identity.principalId]",
            "permissions": {
              "secrets": [
                "get"
              ]
            },
            "tenantId": "[subscription().tenantId]"
          }
        ],
        "sku": {
          "family": "A",
          "name": "standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    }
  ],
  "variables": {
    "storageAccountName": "[concat('regula', uniqueString(resourceGroup().id))]"
  }
}

