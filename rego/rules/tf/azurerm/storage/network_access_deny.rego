# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_azurerm_storage_network_access_deny

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_3.6"
      ]
    },
    "severity": "High"
  },
  "description": "Storage Account default network access rules should deny all traffic. Storage accounts should be configured to deny access to traffic from all networks. Access can be granted to traffic from specific Azure Virtual networks, allowing a secure network boundary for specific applications to be built. Access can also be granted to public internet IP address ranges, to enable connections from specific internet or on-premises clients. When network rules are configured, only applications from allowed networks can access a storage account. When calling from an allowed network, applications continue to require proper authorization (a valid access key or SAS token) to access the storage account.",
  "id": "FG_R00154",
  "title": "Storage Account default network access rules should deny all traffic"
}

resource_type := "MULTIPLE"

storage_accounts = fugue.resources("azurerm_storage_account")
network_rules = fugue.resources("azurerm_storage_account_network_rules")

valid_network_rule(rule) {
  lower(rule.default_action) == "deny"
}

invalid_network_rule(rule) {
  not valid_network_rule(rule)
}

invalid_storage_account(sa) {
  rule := sa.network_rules[_]
  invalid_network_rule(rule)
}

policy[j] {
  rule = network_rules[_]
  valid_network_rule(rule)
  j = fugue.allow_resource(rule)
}

policy[j] {
  rule = network_rules[_]
  not valid_network_rule(rule)
  j = fugue.deny_resource(rule)
}

policy[j] {
  sa = storage_accounts[_]
  not invalid_storage_account(sa)
  j = fugue.allow_resource(sa)
}

policy[j] {
  sa = storage_accounts[_]
  invalid_storage_account(sa)
  j = fugue.deny_resource(sa)
}
