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
package tests.rules.tf.azurerm.sql.inputs.firewall_no_inbound_all_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "azurerm_resource_group.example": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_resource_group",
      "id": "azurerm_resource_group.example",
      "location": "West US",
      "name": "acceptanceTestResourceGroup1"
    },
    "azurerm_sql_firewall_rule.invalidrule1": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_firewall_rule",
      "end_ip_address": "10.0.17.62",
      "id": "azurerm_sql_firewall_rule.invalidrule1",
      "name": "invalidrule1",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "server_name": "mysqlserver",
      "start_ip_address": "0.0.0.0"
    },
    "azurerm_sql_firewall_rule.invalidrule2": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_firewall_rule",
      "end_ip_address": "0.0.0.0",
      "id": "azurerm_sql_firewall_rule.invalidrule2",
      "name": "invalidrule2",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "server_name": "mysqlserver",
      "start_ip_address": "0.0.0.0"
    },
    "azurerm_sql_firewall_rule.invalidrule3": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_firewall_rule",
      "end_ip_address": "255.255.255.255",
      "id": "azurerm_sql_firewall_rule.invalidrule3",
      "name": "invalidrule3",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "server_name": "mysqlserver",
      "start_ip_address": "0.0.0.0"
    },
    "azurerm_sql_firewall_rule.invalidrule4": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_firewall_rule",
      "end_ip_address": "255.255.255.255",
      "id": "azurerm_sql_firewall_rule.invalidrule4",
      "name": "invalidrule4",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "server_name": "mysqlserver",
      "start_ip_address": "10.0.17.62"
    },
    "azurerm_sql_firewall_rule.validrule1": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_firewall_rule",
      "end_ip_address": "10.0.17.62",
      "id": "azurerm_sql_firewall_rule.validrule1",
      "name": "validrule1",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "server_name": "mysqlserver",
      "start_ip_address": "10.0.17.62"
    },
    "azurerm_sql_server.example": {
      "_filepath": "tests/rules/tf/azurerm/sql/inputs/firewall_no_inbound_all_infra.tf",
      "_provider": "azurerm",
      "_type": "azurerm_sql_server",
      "administrator_login": "4dm1n157r470r",
      "administrator_login_password": "4-v3ry-53cr37-p455w0rd",
      "id": "azurerm_sql_server.example",
      "location": "West US",
      "name": "mysqlserver",
      "resource_group_name": "acceptanceTestResourceGroup1",
      "version": "12.0"
    }
  }
}

