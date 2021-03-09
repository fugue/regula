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
package tests.rules.cfn_cloudtrail_s3_access_logging

import data.fugue.regula
import data.tests.rules.cfn.cloudtrail.inputs

test_valid_no_cloudtrail {
    report := regula.report with input as inputs.empty_template_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_s3_access_logging.resources

    count(resources) == 0
}

test_valid_access_logging {
    report := regula.report with input as inputs.s3_access_valid_cloud_trail_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_s3_access_logging.resources

    count(resources) == 1
    resources["CloudTrailLogging"].valid == true
}

test_invalid_access_logging {
    report := regula.report with input as inputs.s3_access_invalid_no_logging_infra.mock_plan_input
    resources := report.rules.cfn_cloudtrail_s3_access_logging.resources

    count(resources) == 1
    resources["CloudTrailLogging"].valid == false
}
