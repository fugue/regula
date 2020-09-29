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

# Network security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH).
# Removing unfettered connectivity to remote console services, such as SSH,
# reduces a server's exposure to risk.
package rules.network_security_group_no_inbound_22

import data.fugue.azure.network_security_group

resource_type = "azurerm_network_security_group"
controls = {
  "CIS_Azure_1.1.0_6-1",
  "NIST‌-800-53_AC‌-4",
  "NIST‌-800-53_SC‌-7a",
  "NIST‌-800-53_SI‌-4a.2",
  "REGULA_R00019",
}

default deny = false

deny {
  network_security_group.group_allows_anywhere_to_port(input, 22)
}
