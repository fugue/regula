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
package rules.cfn_vpc_ingress_22

import data.tests.rules.cloudformation.vpc.inputs.ingress_22_infra

test_ingress_22 {
  pol = policy with input as ingress_22_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["ValidSecurityGroup02"] == true
  by_resource_id["ValidSecurityGroup03"] == true
  by_resource_id["ValidSecurityGroup04Ingress01"] == true
  by_resource_id["InvalidSecurityGroup01"] == false
  by_resource_id["InvalidSecurityGroup02"] == false
  by_resource_id["InvalidSecurityGroup03"] == false
  by_resource_id["InvalidSecurityGroup04Ingress01"] == false
}
