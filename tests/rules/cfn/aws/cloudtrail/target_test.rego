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
package tests.rules.cfn_aws_cloudtrail_target

import data.fugue.regula
import data.tests.rules.cfn.aws.cloudtrail.inputs

test_valid_target {
    report := regula.report with input as inputs.valid_target_infra.mock_plan_input
    resources := report.rules.cfn_aws_cloudtrail_target.resources

    count(resources) == 1
    resources["LoggingBucket"].valid == true
}

test_valid_target_full_check {
    report := regula.report with input as inputs.valid_target_full_check_infra.mock_plan_input
    resources := report.rules.cfn_aws_cloudtrail_target.resources

    count(resources) == 2
    resources["LoggingBucket"].valid == true
    resources["LoggingBucket2"].valid == true
}

test_invalid_target_public {
    report := regula.report with input as inputs.invalid_target_public_infra.mock_plan_input
    resources := report.rules.cfn_aws_cloudtrail_target.resources

    count(resources) == 1
    resources["LoggingBucket"].valid == false
}

test_invalid_target_public_write {
    report := regula.report with input as inputs.invalid_target_public_write_infra.mock_plan_input
    resources := report.rules.cfn_aws_cloudtrail_target.resources

    count(resources) == 1
    resources["LoggingBucket"].valid == false
}
