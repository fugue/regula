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
package rules.cfn_vpc_default_security_group

import data.tests.rules.cloudformation.vpc.inputs.default_security_group_infra

test_default_security_group {
  pol = policy with input as default_security_group_infra.mock_input
  count(pol) == 1
  pol[_] = resource
  resource.id == "Vpc01InvalidIngress"
  resource.valid == false
}
