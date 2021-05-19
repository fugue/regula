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
package rules.tf_azurerm_sql_firewall_no_inbound_all

import data.tests.rules.tf.azurerm.sql.inputs.firewall_no_inbound_all_infra_json

test_sql_server_firewall_no_inbound_all {
  resources = firewall_no_inbound_all_infra_json.mock_resources
  not deny with input as resources["azurerm_sql_firewall_rule.validrule1"]
  deny with input as resources["azurerm_sql_firewall_rule.invalidrule1"]
  deny with input as resources["azurerm_sql_firewall_rule.invalidrule2"]
  deny with input as resources["azurerm_sql_firewall_rule.invalidrule3"]
  deny with input as resources["azurerm_sql_firewall_rule.invalidrule4"]
}
