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
package tests.rules.tf.azurerm.network.inputs.security_group_no_inbound_3389_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_network_security_group.invalidnsg1": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.invalidnsg1",
      "location": "West US",
      "name": "invalidnsg1",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "security_rule": [
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_range": "*",
          "direction": "Inbound",
          "name": "testrule1",
          "priority": 100,
          "protocol": "Tcp",
          "source_address_prefix": "*",
          "source_port_range": "*"
        },
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_ranges": [
            "30-50",
            "235"
          ],
          "direction": "Inbound",
          "name": "testrule2",
          "priority": 101,
          "protocol": "Tcp",
          "source_address_prefixes": [
            "10.10.10.10"
          ],
          "source_port_range": "*"
        }
      ]
    },
    "azurerm_network_security_group.invalidnsg2": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.invalidnsg2",
      "location": "West US",
      "name": "invalidnsg2",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "security_rule": [
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_range": "3389",
          "direction": "Inbound",
          "name": "testrule3",
          "priority": 103,
          "protocol": "Tcp",
          "source_address_prefix": "0.0.0.0/0",
          "source_port_range": "*"
        }
      ]
    },
    "azurerm_network_security_group.testnsg": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.testnsg",
      "location": "West US",
      "name": "testnsg",
      "resource_group_name": "acceptanceTestResourceGroup1"
    },
    "azurerm_network_security_group.validnsg1": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.validnsg1",
      "location": "West US",
      "name": "validnsg1",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "security_rule": [
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_range": "20",
          "direction": "Inbound",
          "name": "testrule4",
          "priority": 100,
          "protocol": "Tcp",
          "source_address_prefix": "Internet",
          "source_port_range": "*"
        },
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_ranges": [
            "3380-3395",
            "235"
          ],
          "direction": "Inbound",
          "name": "testrule5",
          "priority": 101,
          "protocol": "Tcp",
          "source_address_prefixes": [
            "10.10.10.10"
          ],
          "source_port_range": "*"
        }
      ]
    },
    "azurerm_network_security_rule.invalidrule1": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "*",
      "destination_port_range": "3350-3400",
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.invalidrule1",
      "name": "invalidrule1",
      "network_security_group_name": "testnsg",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "source_address_prefixes": [
        "10.10.10.10",
        "*"
      ],
      "source_port_range": "*"
    },
    "azurerm_network_security_rule.invalidrule2": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "*",
      "destination_port_ranges": [
        "3389",
        "3567"
      ],
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.invalidrule2",
      "name": "validrule2",
      "network_security_group_name": "testnsg",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "source_address_prefix": "Any",
      "source_port_range": "*"
    },
    "azurerm_network_security_rule.invalidrule3": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "0.0.0.0/0",
      "destination_port_ranges": [
        "3350-3400",
        "4300"
      ],
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.invalidrule3",
      "name": "validrule3",
      "network_security_group_name": "testnsg",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "source_address_prefix": "Any",
      "source_port_range": "*"
    },
    "azurerm_network_security_rule.validrule1": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "*",
      "destination_port_range": "34",
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.validrule1",
      "name": "validrule1",
      "network_security_group_name": "testnsg",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "source_address_prefixes": [
        "10.10.10.10",
        "*"
      ],
      "source_port_range": "*"
    },
    "azurerm_network_security_rule.validrule2": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "*",
      "destination_port_range": "3389",
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.validrule2",
      "name": "validrule2",
      "network_security_group_name": "testnsg",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "source_address_prefixes": [
        "10.10.10.10"
      ],
      "source_port_range": "*"
    },
    "azurerm_resource_group.example": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/security_group_no_inbound_3389_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.example",
      "location": "West US",
      "name": "acceptanceTestResourceGroup1"
    }
  }
}

