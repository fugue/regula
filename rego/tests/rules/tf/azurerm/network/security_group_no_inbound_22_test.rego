# Copyright 2020 Fugue, Inc.
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
package rules.tf_azurerm_network_security_group_no_inbound_22

import data.tests.rules.tf.azurerm.network.inputs.security_group_no_inbound_22_infra_json

test_network_security_group_no_inbound_22 {
  pol = policy with input as security_group_no_inbound_22_infra_json.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["azurerm_network_security_group.validnsg1"] == true
  by_resource_id["azurerm_network_security_group.invalidnsg1"] == false
  by_resource_id["azurerm_network_security_group.invalidnsg2"] == false
  by_resource_id["azurerm_network_security_rule.validrule1"] == true
  by_resource_id["azurerm_network_security_rule.validrule2"] == true
  by_resource_id["azurerm_network_security_rule.invalidrule1"] == false
  by_resource_id["azurerm_network_security_rule.invalidrule2"] == false
  by_resource_id["azurerm_network_security_rule.invalidrule3"] == false
}
