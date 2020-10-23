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
package tests.rules.vpc_flow_log

import data.fugue.regula
import data.tests.rules.aws.inputs.vpc_flow_log_infra.mock_plan_input

test_vpc_flow_log {
  report := regula.report with input as mock_plan_input
  resources := report.rules.vpc_flow_log.resources

  resources["aws_vpc.valid_vpc"].valid == true
  resources["aws_vpc.invalid_vpc"].valid == false
}
