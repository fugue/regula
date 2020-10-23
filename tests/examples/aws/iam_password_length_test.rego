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
package tests.rules.iam_password_length

import data.fugue.regula
import data.tests.examples.aws.inputs.iam_password_length_infra.mock_plan_input

test_iam_password_length {
  report := regula.report with input as mock_plan_input
  resources := report.rules.iam_password_length.resources
  resources["aws_iam_account_password_policy.valid"].valid == true
  resources["aws_iam_account_password_policy.invalid_1"].valid == false
  resources["aws_iam_account_password_policy.invalid_2"].valid == false

  empty_report := regula.report with input as {}
  empty_report.rules.iam_password_length.valid == false
}
