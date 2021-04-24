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
package rules.cfn_lambda_function_not_public

import data.tests.rules.cfn.lambda.inputs

test_valid_empty_document {
    pol = policy with input as inputs.empty_template_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 0
}

test_valid_private_function {
    pol = policy with input as inputs.valid_function_not_public_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_valid_private_function_sam {
    pol = policy with input as inputs.valid_function_not_public_sam_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_valid_private_function_account_permission {
    pol = policy with input as inputs.valid_function_not_public_account_permission_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_valid_private_function_account_permission_sam {
    pol = policy with input as inputs.valid_function_not_public_account_permission_sam_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_valid_private_function_service_permission {
    pol = policy with input as inputs.valid_function_not_public_service_permission_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_valid_private_function_service_permission_sam {
    pol = policy with input as inputs.valid_function_not_public_service_permission_sam_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == true
}

test_invalid_public_function {
    pol = policy with input as inputs.invalid_function_not_public_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 6
    by_resource_id["Function"] == false
    by_resource_id["Function2"] == false
    by_resource_id["Function3"] == false
    by_resource_id["Function4"] == false
    by_resource_id["Function5"] == false
    by_resource_id["Function6"] == false
}

test_invalid_public_function_sam {
    pol = policy with input as inputs.invalid_function_not_public_sam_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == false
}

test_invalid_public_function_with_valid {
    pol = policy with input as inputs.invalid_function_not_public_with_valid_infra.mock_input
    by_resource_id = {p.id: p.valid | pol[p]}
    count(by_resource_id) == 1
    by_resource_id["Function"] == false
}
