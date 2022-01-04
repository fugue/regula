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
package tests.rules.arm.network.inputs.security_group_no_inbound_22_infra_json

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
      "name": "RegulaSG1",
      "properties": {
        "securityRules": [
          {
            "name": "Rule1",
            "properties": {
              "access": "Allow",
              "destinationAddressPrefix": "*",
              "destinationPortRange": "*",
              "direction": "Inbound",
              "priority": 110,
              "protocol": "*",
              "sourceAddressPrefix": "*",
              "sourcePortRange": "*"
            }
          }
        ]
      },
      "type": "Microsoft.Network/networkSecurityGroups"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "RegulaSG1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaSG1/Rule2",
      "properties": {
        "access": "Deny",
        "destinationAddressPrefix": "*",
        "destinationPortRange": "*",
        "direction": "Inbound",
        "priority": 120,
        "protocol": "*",
        "sourceAddressPrefix": "*",
        "sourcePortRange": "*"
      },
      "type": "Microsoft.Network/networkSecurityGroups/securityRules"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "RegulaSG1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaSG1/Rule3",
      "properties": {
        "access": "Allow",
        "destinationAddressPrefix": "*",
        "destinationPortRange": "22",
        "direction": "Inbound",
        "priority": 130,
        "protocol": "*",
        "sourceAddressPrefix": "*",
        "sourcePortRange": "*"
      },
      "type": "Microsoft.Network/networkSecurityGroups/securityRules"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "RegulaSG1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaSG1/Rule4",
      "properties": {
        "access": "Allow",
        "destinationAddressPrefix": "*",
        "destinationPortRanges": [
          "9-10",
          "21-23"
        ],
        "direction": "Inbound",
        "priority": 140,
        "protocol": "*",
        "sourceAddressPrefix": "*",
        "sourcePortRange": "*"
      },
      "type": "Microsoft.Network/networkSecurityGroups/securityRules"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "RegulaSG1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaSG1/Rule5",
      "properties": {
        "access": "Allow",
        "destinationAddressPrefix": "*",
        "destinationPortRanges": [
          "9-10",
          "23-25"
        ],
        "direction": "Inbound",
        "priority": 150,
        "protocol": "*",
        "sourceAddressPrefix": "*",
        "sourcePortRange": "*"
      },
      "type": "Microsoft.Network/networkSecurityGroups/securityRules"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "RegulaSG1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaSG1/Rule6",
      "properties": {
        "access": "Allow",
        "destinationAddressPrefix": "*",
        "destinationPortRanges": [
          "9-10",
          "21-22"
        ],
        "direction": "Inbound",
        "priority": 160,
        "protocol": "*",
        "sourceAddressPrefix": "10.0.0.0/24",
        "sourcePortRange": "*"
      },
      "type": "Microsoft.Network/networkSecurityGroups/securityRules"
    }
  ]
}

