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
package rules.tf_aws_vpc_vpc_flow_logging_enabled

import data.tests.rules.tf.aws.vpc.inputs.flow_log_infra_json

test_vpc_vpc_flow_logging_enabled {
  pol = policy with input as flow_log_infra_json.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["aws_vpc.valid_vpc"] == true
  by_resource_id["aws_vpc.invalid_vpc"] == false
}
