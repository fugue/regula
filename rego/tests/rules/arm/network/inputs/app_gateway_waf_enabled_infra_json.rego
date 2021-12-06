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
package tests.rules.arm.network.inputs.app_gateway_waf_enabled_infra_json

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
      "name": "RegulaNet1",
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
            "RegulaNet1"
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
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "Microsoft.Network/virtualNetworks/RegulaNet1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaAG1",
      "properties": {
        "backendAddressPools": [
          {
            "name": "BAP1"
          }
        ],
        "backendHttpSettingsCollection": [
          {
            "name": "BHSC1",
            "properties": {
              "hostName": "example.com",
              "port": 80
            }
          }
        ],
        "frontendIPConfigurations": [
          {
            "name": "FIPC1",
            "properties": {
              "subnet": {
                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', 'RegulaNet1'), '/subnets/Subnet1')]"
              }
            }
          }
        ],
        "frontendPorts": [
          {
            "name": "FP1",
            "properties": {
              "port": 80
            }
          }
        ],
        "gatewayIPConfigurations": [
          {
            "name": "IPC1",
            "properties": {
              "subnet": {
                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', 'RegulaNet1'), '/subnets/Subnet1')]"
              }
            }
          }
        ],
        "httpListeners": [
          {
            "name": "HL1",
            "properties": {
              "frontendIPConfiguration": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'RegulaAG1', 'FIPC1')]"
              },
              "frontendPort": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'RegulaAG1', 'FP1')]"
              }
            }
          }
        ],
        "requestRoutingRules": [
          {
            "name": "RRR1",
            "properties": {
              "backendAddressPool": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'RegulaAG1', 'BAP1')]"
              },
              "backendHttpSettings": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'RegulaAG1', 'BHSC1')]"
              },
              "httpListener": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/httpListeners', 'RegulaAG1', 'HL1')]"
              }
            }
          }
        ],
        "sku": {
          "capacity": 1,
          "name": "WAF_Medium",
          "tier": "WAF"
        }
      },
      "type": "Microsoft.Network/applicationGateways"
    },
    {
      "apiVersion": "2021-03-01",
      "dependsOn": [
        "Microsoft.Network/virtualNetworks/RegulaNet1"
      ],
      "location": "switzerlandnorth",
      "name": "RegulaAG2",
      "properties": {
        "backendAddressPools": [
          {
            "name": "BAP1"
          }
        ],
        "backendHttpSettingsCollection": [
          {
            "name": "BHSC1",
            "properties": {
              "hostName": "example.com",
              "port": 80
            }
          }
        ],
        "frontendIPConfigurations": [
          {
            "name": "FIPC1",
            "properties": {
              "subnet": {
                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', 'RegulaNet1'), '/subnets/Subnet1')]"
              }
            }
          }
        ],
        "frontendPorts": [
          {
            "name": "FP1",
            "properties": {
              "port": 80
            }
          }
        ],
        "gatewayIPConfigurations": [
          {
            "name": "IPC1",
            "properties": {
              "subnet": {
                "id": "[concat(resourceId('Microsoft.Network/virtualNetworks', 'RegulaNet1'), '/subnets/Subnet1')]"
              }
            }
          }
        ],
        "httpListeners": [
          {
            "name": "HL1",
            "properties": {
              "frontendIPConfiguration": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'RegulaAG2', 'FIPC1')]"
              },
              "frontendPort": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'RegulaAG2', 'FP1')]"
              }
            }
          }
        ],
        "requestRoutingRules": [
          {
            "name": "RRR1",
            "properties": {
              "backendAddressPool": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'RegulaAG2', 'BAP1')]"
              },
              "backendHttpSettings": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'RegulaAG2', 'BHSC1')]"
              },
              "httpListener": {
                "id": "[resourceId('Microsoft.Network/applicationGateways/httpListeners', 'RegulaAG2', 'HL1')]"
              }
            }
          }
        ],
        "sku": {
          "capacity": 1,
          "name": "WAF_Medium",
          "tier": "WAF"
        },
        "webApplicationFirewallConfiguration": {
          "enabled": true
        }
      },
      "type": "Microsoft.Network/applicationGateways"
    }
  ]
}

