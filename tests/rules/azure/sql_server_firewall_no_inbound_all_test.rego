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
package tests.rules.sql_server_firewall_no_inbound_all

import data.fugue.regula
import data.tests.rules.azure.inputs.sql_server_firewall_no_inbound_all_infra.mock_plan_input

test_sql_server_firewall_no_inbound_all {
  report := regula.report with input as mock_plan_input
  resources := report.rules.sql_server_firewall_no_inbound_all.resources

  resources["azurerm_sql_firewall_rule.validrule1"].valid == true
  resources["azurerm_sql_firewall_rule.invalidrule1"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule2"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule3"].valid == false
  resources["azurerm_sql_firewall_rule.invalidrule4"].valid == false
}
