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
package rules.tf_azurerm_storage_network_access_trust_microsoft

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_3.7"
      ]
    },
    "severity": "Medium"
  },
  "description": "Storage Accounts should have 'Trusted Microsoft Services' enabled. Some Microsoft services that interact with storage accounts operate from networks that can't be granted access through network rules. Enabling \"Trusted Microsoft Services\" allows Azure Backup, Azure Site Recovery, Azure Networking, Azure Monitor, and other Azure services to access your storage account and bypass any firewall rules.",
  "id": "FG_R00208",
  "title": "Storage Accounts should have 'Trusted Microsoft Services' enabled"
}

resource_type := "MULTIPLE"

storage_accounts = fugue.resources("azurerm_storage_account")
network_rules = fugue.resources("azurerm_storage_account_network_rules")

valid_network_rule(rule) {
  lower(rule.bypass[_]) == "azureservices"
}

valid_storage_account_ids[id] {
  rule := network_rules[_]
  valid_network_rule(rule)
  id := rule.storage_account_name
}

valid_storage_account(sa) {
  rule := sa.network_rules[_]
  valid_network_rule(rule)
} {
  valid_storage_account_ids[sa.id]
} {
  valid_storage_account_ids[sa.name]
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
  valid_storage_account(sa)
  j = fugue.allow_resource(sa)
}

policy[j] {
  sa = storage_accounts[_]
  not valid_storage_account(sa)
  j = fugue.deny_resource(sa)
}
