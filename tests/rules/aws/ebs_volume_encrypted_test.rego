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
package tests.rules.ebs_volume_encrypted

import data.fugue.regula
import data.tests.rules.aws.inputs.ebs_volume_encrypted_infra.mock_plan_input

test_ebs_volume_encrypted {
  report := regula.report with input as mock_plan_input
  resources := report.rules.ebs_volume_encrypted.resources

  resources["aws_ebs_volume.good"].valid == true
  resources["aws_ebs_volume.missing"].valid == false
  resources["aws_ebs_volume.bad"].valid == false
}
