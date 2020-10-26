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
package tests.rules.network_security_group_no_inbound_3389

import data.fugue.regula
import data.tests.rules.azure.inputs.network_security_group_no_inbound_3389_infra.mock_plan_input

test_network_security_group_no_inbound_3389 {
  report := regula.report with input as mock_plan_input
  resources := report.rules.network_security_group_no_inbound_3389.resources

  resources["azurerm_network_security_group.validnsg1"].valid == true
  resources["azurerm_network_security_group.invalidnsg1"].valid == false
  resources["azurerm_network_security_group.invalidnsg2"].valid == false

  resources["azurerm_network_security_rule.validrule1"].valid == true
  resources["azurerm_network_security_rule.validrule2"].valid == true
  resources["azurerm_network_security_rule.invalidrule1"].valid == false
  resources["azurerm_network_security_rule.invalidrule2"].valid == false
  resources["azurerm_network_security_rule.invalidrule3"].valid == false
}
