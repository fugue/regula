# Copyright 2021 Fugue, Inc.
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

package rules.arm_network_security_group_no_inbound_3389

import data.tests.rules.arm.network.inputs.security_group_no_inbound_3389_infra_json as infra

test_rule {
	pol = policy with input as infra.mock_input
	by_resource_id = {p.id: p.valid | pol[p]}
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1"] == false
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1/securityRules/Rule2"] == true
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1/securityRules/Rule3"] == false
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1/securityRules/Rule4"] == false
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1/securityRules/Rule5"] == true
	by_resource_id["Microsoft.Network/networkSecurityGroups/RegulaSG1/securityRules/Rule6"] == true
}
