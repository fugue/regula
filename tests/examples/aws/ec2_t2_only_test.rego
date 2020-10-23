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
package tests.rules.ec2_t2_only

import data.fugue.regula
import data.tests.examples.aws.inputs.ec2_t2_only_infra.mock_plan_input

test_t2_only {
  report := regula.report with input as mock_plan_input
  resources := report.rules.ec2_t2_only.resources
  resources["aws_instance.invalid"].valid == false
  resources["aws_instance.valid_micro"].valid == true
  resources["aws_instance.valid_small"].valid == true
  resources["aws_instance.valid_medium"].valid == true
  resources["aws_instance.valid_large"].valid == true
  resources["aws_instance.valid_xlarge"].valid == true
  resources["aws_instance.valid_2xlarge"].valid == true
}
