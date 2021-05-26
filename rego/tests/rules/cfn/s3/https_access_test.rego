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
package rules.cfn_s3_https_access

import data.tests.rules.cfn.s3.inputs

test_valid_empty_document {
    pol = policy with input as inputs.empty_template_infra_yaml.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 0
}

test_valid_https_access_bucket_policy {
    pol = policy with input as inputs.valid_https_access_bucket_policy_infra_yaml.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 2
    by_resource_id["Bucket1"] == true
    by_resource_id["Bucket2"] == true
}

test_invalid_https_access_bucket_policy {
    pol = policy with input as inputs.invalid_https_access_bucket_policy_infra_yaml.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 2
    by_resource_id["Bucket1"] == false
    by_resource_id["Bucket2"] == false
}

test_invalid_missing {
    pol = policy with input as inputs.invalid_missing_infra_yaml.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Bucket"] == false
}
