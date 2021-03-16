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
package rules.cfn_cloudtrail_s3_access_logging

import data.tests.rules.cfn.cloudtrail.inputs

test_valid_no_cloudtrail {
    pol = policy with input as inputs.empty_template_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 0
}

test_valid_access_logging {
    pol = policy with input as inputs.valid_s3_access_logging_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["CloudTrailLogging"] == true
}

test_invalid_access_logging {
    pol = policy with input as inputs.invalid_s3_access_logging_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["CloudTrailLogging"] == false
}
