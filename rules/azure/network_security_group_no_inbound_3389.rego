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
package rules.network_security_group_no_inbound_3389

import data.fugue
import data.fugue.azure.network_security_group

__rego__metadoc__ := {
  "id": "FG_R00191",
  "title": "Network security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)",
  "description": "Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 3389 (RDP). The potential security problem with using RDP over the Internet is that attackers can use various brute force techniques to gain access to Azure Virtual Machines. Once the attackers gain access, they can use a virtual machine as a launch point for compromising other machines on an Azure Virtual Network or even attack networked devices outside of Azure.",
  "custom": {
    "controls": {
      "CISAZURE": [
        "CISAZURE_6.2"
      ]
    },
    "severity": "High"
  }
}

resource_type = "MULTIPLE"

security_groups = fugue.resources("azurerm_network_security_group")

policy[p] {
  security_group = security_groups[_]
  network_security_group.group_allows_anywhere_to_port(security_group, 3389)
  p = fugue.deny_resource(security_group)
} {
  security_group = security_groups[_]
  not network_security_group.group_allows_anywhere_to_port(security_group, 3389)
  p = fugue.allow_resource(security_group)
}

security_rules = fugue.resources("azurerm_network_security_rule")

policy[p] {
  security_rule = security_rules[_]
  network_security_group.rule_allows_anywhere_to_port(security_rule, 3389)
  p = fugue.deny_resource(security_rule)
} {
  security_rule = security_rules[_]
  not network_security_group.rule_allows_anywhere_to_port(security_rule, 3389)
  p = fugue.allow_resource(security_rule)
}
