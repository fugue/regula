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
package rules.cfn_aws_cloudtrail_cloudwatch

import data.tests.rules.cfn.aws.cloudtrail.inputs

test_valid_cloudwatch {
    resources = inputs.valid_cloudwatch_infra.mock_resources
    allow with input as resources["CloudTrailLogging"]
}

test_invalid_cloudwatch {
    resources = inputs.invalid_cloudwatch_infra.mock_resources
    not allow with input as resources["CloudTrailLogging"]
}

test_invalid_cloudwatch_with_valid {
    resources = inputs.invalid_cloudwatch_with_valid_infra.mock_resources
    not allow with input as resources["InvalidCloudTrailLogging"]
    allow with input as resources["ValidCloudTrailLogging"]
}
