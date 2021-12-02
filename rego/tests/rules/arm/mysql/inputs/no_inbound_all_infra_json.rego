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
package rego.tests.rules.arm.mysql.inputs.no_inbound_all_infra_json

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
      "apiVersion": "2018-10-01",
      "location": "switzerlandnorth",
      "name": "VNet1",
      "properties": {
        "addressSpace": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ]
        }
      },
      "resources": [
        {
          "apiVersion": "2018-10-01",
          "dependsOn": [
            "VNet1"
          ],
          "name": "Subnet1",
          "properties": {
            "addressPrefix": "10.0.0.0/24"
          },
          "type": "subnets"
        }
      ],
      "type": "Microsoft.Network/virtualNetworks"
    },
    {
      "apiVersion": "2017-12-01",
      "location": "switzerlandnorth",
      "name": "Server1",
      "properties": {
        "administratorLogin": "admin",
        "administratorLoginPassword": "hunter2",
        "storageProfile": {
          "backupRetentionDays": "7",
          "geoRedundantBackup": "Disabled",
          "storageMB": "5120"
        },
        "version": "5.7"
      },
      "resources": [
        {
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "Microsoft.DBforMySQL/servers/Server1"
          ],
          "name": "Subnet1",
          "properties": {
            "virtualNetworkSubnetId": "Microsoft.Network/virtualNetworks/VNet1/subnets/Subnet1"
          },
          "type": "virtualNetworkRules"
        },
        {
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "Microsoft.DBforMySQL/servers/Server1"
          ],
          "name": "Rule1",
          "properties": {
            "endIpAddress": "0.0.0.0",
            "startIpAddress": "0.0.0.0"
          },
          "type": "firewallRules"
        },
        {
          "apiVersion": "2017-12-01",
          "dependsOn": [
            "Microsoft.DBforMySQL/servers/Server1"
          ],
          "name": "Rule2",
          "properties": {
            "endIpAddress": "10.0.255.0",
            "startIpAddress": "10.0.0.0"
          },
          "type": "firewallRules"
        }
      ],
      "sku": {
        "capacity": "2",
        "family": "Gen5",
        "name": "B_Gen4_1",
        "tier": "Basic"
      },
      "type": "Microsoft.DBforMySQL/servers"
    }
  ]
}

