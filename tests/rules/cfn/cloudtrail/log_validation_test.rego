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
package tests.rules.cfn_cloudtrail_log_validation

import data.fugue.regula
import data.tests.rules.cfn.cloudtrail.inputs

test_valid_cloudtrail_log_validation {
    report := regula.report with input as inputs.valid_log_validation_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_log_validation.resources

    count(resources) == 1
    resources["CloudTrailLogging"].valid == true
}

test_invalid_cloudtrail_log_validation{
    report := regula.report with input as inputs.invalid_log_validation_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_log_validation.resources

    count(resources) == 1
    resources["CloudTrailLogging"].valid == false
}

test_invalidLogFileValidationWithValid {
    report := regula.report with input as inputs.invalid_log_validation_with_valid_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_log_validation.resources

    count(resources) == 2
    resources["InvalidCloudTrailLogging"].valid == false
    resources["ValidCloudTrailLogging"].valid == true
}
