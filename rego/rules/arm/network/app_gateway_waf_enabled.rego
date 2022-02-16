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

package rules.arm_network_app_gateway_waf_enabled

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Azure Application Gateway offers a web application firewall (WAF) that provides centralized protection of your web applications from common exploits and vulnerabilities. Web applications are increasingly targeted by malicious attacks that exploit commonly known vulnerabilities.",
  "id": "FG_R00224",
  "title": "Ensure Azure Application Gateway Web application firewall (WAF) is enabled"
}

input_type := "arm"

resource_type := "Microsoft.Network/applicationGateways"

default allow = false

allow {
	waf_sku_tiers[input.properties.sku.tier]
	input.properties.webApplicationFirewallConfiguration.enabled == true
}

waf_sku_tiers = {"WAF", "WAF_v2"}
