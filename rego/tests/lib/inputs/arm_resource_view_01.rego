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
package tests.lib.inputs.arm_resource_view_01

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "resources": [
    {
      "type": "Microsoft.Network/virtualNetworks",
      "apiVersion": "2018-10-01",
      "name": "VNet1",
      "location": "switzerlandnorth",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ]
        }
      },
      "resources": [
        {
          "type": "subnets",
          "apiVersion": "2018-10-01",
          "name": "Subnet1",
          "dependsOn": [
            "VNet1"
          ],
          "properties": {
            "addressPrefix": "10.0.0.0/24"
          }
        }
      ]
    },
    {
      "type": "Microsoft.Network/virtualNetworks/subnets",
      "apiVersion": "2018-10-01",
      "name": "VNet1/Subnet2",
      "dependsOn": [
        "VNet1"
      ],
      "properties": {
        "addressPrefix": "10.0.1.0/24"
      }
    }
  ]
}
