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
package tests.rules.arm.key_vault.inputs.recoverable_infra_json

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
      "apiVersion": "2021-04-01",
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
        "enablePurgeProtection": true,
        "enableSoftDelete": true,
        "sku": {
          "family": "A",
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-04-01",
      "location": "[resourceGroup().location]",
      "name": "invalidUnset",
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
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-04-01",
      "location": "[resourceGroup().location]",
      "name": "invalidEnablePurgeProtection",
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
        "enablePurgeProtection": false,
        "enableSoftDelete": true,
        "sku": {
          "family": "A",
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    },
    {
      "apiVersion": "2021-04-01",
      "location": "[resourceGroup().location]",
      "name": "invalidEnableSoftDelete",
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
        "enablePurgeProtection": true,
        "enableSoftDelete": false,
        "sku": {
          "family": "A",
          "name": "Standard"
        },
        "tenantId": "[subscription().tenantId]"
      },
      "type": "Microsoft.KeyVault/vaults"
    }
  ]
}

