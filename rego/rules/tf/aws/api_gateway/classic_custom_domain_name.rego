# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_api_gateway_classic_custom_domain_name

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name


__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "API Gateway classic custom domains should use secure TLS protocol versions (1.2 and above). The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology. Encryption should be set with the latest version of TLS where possible. Versions prior to TLS 1.2 are deprecated and usage may pose security risks.",
  "id": "FG_R00375",
  "title": "API Gateway classic custom domains should use secure TLS protocol versions (1.2 and above)"
}

resource_type := "aws_api_gateway_domain_name"

invalid_settings = {"TLS_1_0"}

default deny = false

deny {
  invalid_settings[input.security_policy]
}
