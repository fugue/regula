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
package tests.rules.arm.authorization.inputs.custom_owner_role_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "storageName": {
      "defaultValue": "[concat('storage', uniqueString(resourceGroup().id))]",
      "type": "string"
    }
  },
  "resources": [
    {
      "apiVersion": "2021-02-01",
      "name": "invalidTopLevel",
      "properties": {
        "assignableScopes": [
          "/"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "invalidActionsArr",
      "properties": {
        "assignableScopes": [
          "/"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "invalidHardcodedId",
      "properties": {
        "assignableScopes": [
          "/subscriptions/479a226b-4153-48f7-8943-3e8e388a93cb"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "invalidConcat",
      "properties": {
        "assignableScopes": [
          "[concat('/subscriptions/', subscription().subscriptionId)]"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "invalidSubscriptionId",
      "properties": {
        "assignableScopes": [
          "[subscription().id]"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "validAction",
      "properties": {
        "assignableScopes": [
          "[subscription().id]"
        ],
        "permissions": [
          {
            "actions": "Microsoft.Resources/subscriptions/read"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    },
    {
      "apiVersion": "2021-02-01",
      "name": "validScope",
      "properties": {
        "assignableScopes": [
          "[concat('Microsoft.Storage/storageAccounts', '/', parameters('storageName'))]"
        ],
        "permissions": [
          {
            "actions": "*"
          }
        ]
      },
      "type": "Microsoft.Authorization/roleDefinitions"
    }
  ]
}

