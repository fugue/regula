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
package rules.cfn_aws_api_gateway_classic_custom_domain_name

import data.tests.rules.cfn.aws.api_gateway.inputs

test_valid_classic_custom_domain_name {
  pol = policy with input as inputs.valid_classic_custom_domain_name_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 1
  by_resource_id["CustomDomainName"] == true
}

test_valid_classic_custom_domain_name_sam {
  pol = policy with input as inputs.valid_classic_custom_domain_name_sam_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 1
  by_resource_id["ServerlessAPI"] == true
}

test_invalid_classic_custom_domain_name {
  pol = policy with input as inputs.invalid_classic_custom_domain_name_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 2
  by_resource_id["CustomDomainName"] == false
  by_resource_id["CustomDomainName2"] == false
}

test_invalid_classic_custom_domain_name_sam {
  pol = policy with input as inputs.invalid_classic_custom_domain_name_sam_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 2
  by_resource_id["ServerlessAPI"] == false
  by_resource_id["ServerlessAPI2"] == false
}
