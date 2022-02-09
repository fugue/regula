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
package rules.cfn_api_gateway_v2_custom_domain_name

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "API Gateway v2 custom domains should use secure TLS protocol versions (1.2 and above). The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology. Encryption should be set with the latest version of TLS where possible. Versions prior to TLS 1.2 are deprecated and usage may pose security risks.",
  "id": "FG_R00376",
  "title": "API Gateway v2 custom domains should use secure TLS protocol versions (1.2 and above)"
}

input_type := "cfn"
resource_type := "MULTIPLE"

domain_names = fugue.resources("AWS::ApiGatewayV2::DomainName")
serverless_apis = fugue.resources("AWS::Serverless::HttpApi")

invalid_settings = {"TLS_1_0"}

valid_domain_config(domain_config) {
  domain_config.SecurityPolicy != null
  not invalid_settings[domain_config.SecurityPolicy]
}

valid_domain_names[id] {
  domain_name := domain_names[id]
  count(domain_name.DomainNameConfigurations) > 0
  domain_config := domain_name.DomainNameConfigurations[_]
  valid_domain_config(domain_config)
}

policy[j] {
  domain_name := domain_names[id]
  valid_domain_names[id]
  j = fugue.allow_resource(domain_name)
} {
  domain_name := domain_names[id]
  not valid_domain_names[id]
  j = fugue.deny_resource(domain_name)
} {
  serverless_api := serverless_apis[_]
  serverless_api.Domain != null
  valid_domain_config(serverless_api.Domain)
  j = fugue.allow_resource(serverless_api)
} {
  serverless_api := serverless_apis[_]
  serverless_api.Domain != null
  not valid_domain_config(serverless_api.Domain)
  j = fugue.deny_resource(serverless_api)
}
