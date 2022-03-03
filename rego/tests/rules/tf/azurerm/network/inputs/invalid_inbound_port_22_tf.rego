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
package tests.rules.tf.azurerm.network.inputs.invalid_inbound_port_22_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_network_security_group.bad-group-01": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/invalid_inbound_port_22.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.bad-group-01",
      "location": "eastus",
      "name": "bad-group-01",
      "resource_group_name": "vst-rg"
    },
    "azurerm_network_security_group.bad-group-02": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/invalid_inbound_port_22.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_group",
      "id": "azurerm_network_security_group.bad-group-02",
      "location": "eastus",
      "name": "bad-group-02",
      "resource_group_name": "vst-rg",
      "security_rule": [
        {
          "access": "Allow",
          "destination_address_prefix": "*",
          "destination_port_ranges": [
            "22"
          ],
          "direction": "Inbound",
          "name": "bad-rule-01",
          "priority": 100,
          "protocol": "Tcp",
          "source_address_prefixes": [
            "0.0.0.0"
          ],
          "source_port_range": "*"
        }
      ]
    },
    "azurerm_network_security_rule.bad-rule-01": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/invalid_inbound_port_22.tf",
      "_provider": "azurerm",
      "_type": "azurerm_network_security_rule",
      "access": "Allow",
      "destination_address_prefix": "*",
      "destination_port_range": "22",
      "direction": "Inbound",
      "id": "azurerm_network_security_rule.bad-rule-01",
      "name": "bad-rule-01",
      "network_security_group_name": "bad-group-01",
      "priority": 100,
      "protocol": "Tcp",
      "resource_group_name": "vst-rg",
      "source_address_prefix": "*",
      "source_port_range": "*"
    },
    "azurerm_resource_group.main": {
      "_filepath": "tests/rules/tf/azurerm/network/inputs/invalid_inbound_port_22.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.main",
      "location": "eastus",
      "name": "vst-rg"
    }
  }
}

