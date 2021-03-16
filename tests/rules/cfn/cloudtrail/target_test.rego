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
package rules.cfn_cloudtrail_target

import data.tests.rules.cfn.cloudtrail.inputs

test_valid_target {
    pol = policy with input as inputs.valid_target_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["LoggingBucket"] == true
}

test_valid_target_full_check {
    pol = policy with input as inputs.valid_target_full_check_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 2
    by_resource_id["LoggingBucket"] == true
    by_resource_id["LoggingBucket2"] == true
}

test_invalid_target_public {
    pol = policy with input as inputs.invalid_target_public_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["LoggingBucket"] == false
}

test_invalid_target_public_write {
    pol = policy with input as inputs.invalid_target_public_write_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["LoggingBucket"] == false
}
