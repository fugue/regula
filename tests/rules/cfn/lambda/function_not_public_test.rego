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
package tests.rules.cfn_lambda_function_not_public

import data.fugue.regula
import data.tests.rules.cfn.lambda.inputs

test_valid_empty_document {
    report := regula.report with input as inputs.empty_template_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 0
}

test_valid_private_function {
    report := regula.report with input as inputs.valid_private_function_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_valid_private_function_sam {
    report := regula.report with input as inputs.valid_private_function_sam_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_valid_private_function_account_permission {
    report := regula.report with input as inputs.valid_private_function_account_permission_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_valid_private_function_account_permission_sam {
    report := regula.report with input as inputs.valid_private_function_account_permission_sam_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_valid_private_function_service_permission {
    report := regula.report with input as inputs.valid_private_function_service_permission_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_valid_private_function_service_permission_sam {
    report := regula.report with input as inputs.valid_private_function_service_permission_sam_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == true
}

test_invalid_public_function {
    report := regula.report with input as inputs.invalid_public_function_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 6
    resources["Function"].valid == false
    resources["Function2"].valid == false
    resources["Function3"].valid == false
    resources["Function4"].valid == false
    resources["Function5"].valid == false
    resources["Function6"].valid == false
}

test_invalid_public_function_sam {
    report := regula.report with input as inputs.invalid_public_function_sam_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == false
}

test_invalid_public_function_with_valid {
    report := regula.report with input as inputs.invalid_public_function_with_valid_infra.mock_plan_input
    resources := report.rules.cfn_lambda_function_not_public.resources

    count(resources) == 1
    resources["Function"].valid == false
}
