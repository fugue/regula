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
package rules.tf_azurerm_sql_no_inbound_azure_all

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_12.4",
        "CIS-Controls_v7.1_9.2",
        "CIS-Controls_v7.1_9.4"
      ]
    },
    "severity": "High"
  },
  "description": "SQL Server firewall rules should not permit start and end IP addresses to be 0.0.0.0. Adding a rule with range 0.0.0.0 to 0.0.0.0 is the same as enabling the \"Allow access to Azure services\" setting, which allows all connections from Azure, including from other subscriptions. Disabling this setting helps prevent malicious Azure users from connecting to your database and accessing sensitive data.",
  "id": "FG_R00221",
  "title": "SQL Server firewall rules should not permit start and end IP addresses to be 0.0.0.0"
}

firewall_rules = fugue.resources("azurerm_sql_firewall_rule")

# An invalid address has start IP set to `0.0.0.0` and end IP set to `0.0.0.0`
invalid_address(firewall_rule) {
  firewall_rule.start_ip_address == "0.0.0.0"
  firewall_rule.end_ip_address == "0.0.0.0"
}

resource_type = "MULTIPLE"

policy[j] {
  firewall_rule = firewall_rules[_]
  invalid_address(firewall_rule)
  j = fugue.deny_resource(firewall_rule)
} {
  firewall_rule = firewall_rules[_]
  not invalid_address(firewall_rule)
  j = fugue.allow_resource(firewall_rule)
}

