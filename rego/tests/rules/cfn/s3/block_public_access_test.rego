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
package rules.cfn_s3_block_public_access

import data.tests.rules.cfn.s3.inputs

test_valid {
    resources = inputs.valid_block_public_access_infra_yaml.mock_resources
    allow with input as resources["Bucket"]
}

test_invalid {
    resources = inputs.invalid_block_public_access_infra_yaml.mock_resources
    not allow with input as resources["Bucket1"]
    not allow with input as resources["Bucket2"]
}
