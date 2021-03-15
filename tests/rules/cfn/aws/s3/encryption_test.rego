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
package tests.rules.cfn_aws_s3_encryption

import data.fugue.regula
import data.tests.rules.cfn.aws.s3.inputs

test_valid_encryption {
    report := regula.report with input as inputs.valid_encryption_infra.mock_plan_input
    resources := report.rules.cfn_aws_s3_encryption.resources

    count(resources) == 1
    resources["Bucket"].valid == true
}

test_invalid_encryption_missing {
    report := regula.report with input as inputs.invalid_encryption_missing_infra.mock_plan_input
    resources := report.rules.cfn_aws_s3_encryption.resources

    count(resources) == 1
    resources["Bucket"].valid == false
}

test_invalid_encryption_with_valid {
    report := regula.report with input as inputs.invalid_encryption_with_valid_infra.mock_plan_input
    resources := report.rules.cfn_aws_s3_encryption.resources

    count(resources) == 2
    resources["Bucket"].valid == true
    resources["InvalidBucket"].valid == false
}
