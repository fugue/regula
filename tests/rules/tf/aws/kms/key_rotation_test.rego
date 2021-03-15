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
package tests.rules.tf_aws_kms_key_rotation

import data.fugue.regula
import data.tests.rules.tf.aws.kms.inputs.key_rotation_infra.mock_plan_input

test_kms_rotate {
  report := regula.report with input as mock_plan_input
  resources := report.rules.tf_aws_kms_key_rotation.resources

  resources["aws_kms_key.valid"].valid == true
  resources["aws_kms_key.invalid"].valid == false
}
