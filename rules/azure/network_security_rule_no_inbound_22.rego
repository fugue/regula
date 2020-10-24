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
package rules.network_security_rule_no_inbound_22

import data.fugue.azure.network_security_group

__rego__metadoc__ := {
  "id": "FG_R00190",
  "title": "Network security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH)",
  "description": "Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH). The potential security problem with using SSH over the internet is that attackers can use various brute force techniques to gain access to Azure Virtual Machines. Once the attackers gain access, they can use a virtual machine as a launch point for compromising other machines on the Azure Virtual Network or even attack networked devices outside of Azure.",
  "custom": {
    "controls": {
      "CISAZURE": [
        "CISAZURE_6.1"
      ],
      "NIST": [
        "NIST-800-53_AC-4",
        "NIST-800-53_SC-7a",
        "NIST-800-53_SI-4a.2"
      ]
    }
  }
}

resource_type = "azurerm_network_security_rule"

default deny = false

deny {
  network_security_group.rule_allows_anywhere_to_port(input, 22)
}
