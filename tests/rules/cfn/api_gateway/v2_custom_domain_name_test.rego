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
package tests.rules.cfn_api_gateway_v2_custom_domain_name

import data.fugue.regula
import data.tests.rules.cfn.api_gateway.inputs

test_valid_v2_custom_domain_name {
  report := regula.report with input as inputs.valid_v2_custom_domain_name_infra.mock_plan_input
  resources := report.rules.cfn_api_gateway_v2_custom_domain_name.resources

  count(resources) == 1
  resources["CustomDomainName"].valid == true
}

test_valid_v2_custom_domain_name_sam {
  report := regula.report with input as inputs.valid_v2_custom_domain_name_sam_infra.mock_plan_input
  resources := report.rules.cfn_api_gateway_v2_custom_domain_name.resources

  count(resources) == 1
  resources["ServerlessAPI"].valid == true
}

test_invalid_v2_custom_domain_name {
  report := regula.report with input as inputs.invalid_v2_custom_domain_name_infra.mock_plan_input
  resources := report.rules.cfn_api_gateway_v2_custom_domain_name.resources

  count(resources) == 4
  resources["CustomDomainName"].valid == false
  resources["CustomDomainName2"].valid == false
  resources["CustomDomainName3"].valid == false
  resources["CustomDomainName4"].valid == false
}

test_invalid_v2_custom_domain_name_sam {
  report := regula.report with input as inputs.invalid_v2_custom_domain_name_sam_infra.mock_plan_input
  resources := report.rules.cfn_api_gateway_v2_custom_domain_name.resources

  count(resources) == 2
  resources["ServerlessAPI"].valid == false
  resources["ServerlessAPI2"].valid == false
}
