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
package tests.rules.cfn_s3_https_access

import data.fugue.regula
import data.tests.rules.cfn.s3.inputs

test_valid_empty_document {
    report := regula.report with input as inputs.empty_template_infra.mock_plan_input
    resources := report.rules.cfn_s3_https_access.resources

    count(resources) == 0
}

test_valid_https_access_bucket_policy {
    report := regula.report with input as inputs.valid_https_access_bucket_policy_infra.mock_plan_input
    resources := report.rules.cfn_s3_https_access.resources

    count(resources) == 2
    resources["Bucket1"].valid == true
    resources["Bucket2"].valid == true
}

test_invalid_https_access_bucket_policy {
    report := regula.report with input as inputs.invalid_https_access_bucket_policy_infra.mock_plan_input
    resources := report.rules.cfn_s3_https_access.resources

    count(resources) == 2
    resources["Bucket1"].valid == false
    resources["Bucket2"].valid == false
}

test_invalid_missing {
    report := regula.report with input as inputs.invalid_missing_infra.mock_plan_input
    resources := report.rules.cfn_s3_https_access.resources

    count(resources) == 1
    resources["Bucket"].valid == false
}
