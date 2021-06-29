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
package rules.tf_azurerm_network_application_gateway_waf_enabled

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "Ensure Azure Application Gateway Web application firewall (WAF) is enabled. Azure Application Gateway offers a web application firewall (WAF) that provides centralized protection of your web applications from common exploits and vulnerabilities. Web applications are increasingly targeted by malicious attacks that exploit commonly known vulnerabilities.",
  "id": "FG_R00224",
  "title": "Ensure Azure Application Gateway Web application firewall (WAF) is enabled"
}

# WAF configuration options are only available in WAF or WAF_v2 tiers.
is_waf_sku(sku) {
    sku[_].tier == "WAF"
} {
    sku[_].tier == "WAF_v2"
}

# WAF must be enabled
is_waf_enabled(waf_config) {
    waf_config[_].enabled = true
}

valid_app_gw(gw) {
    is_waf_sku(gw.sku)
    is_waf_enabled(gw.waf_configuration)
}

app_gws = fugue.resources("azurerm_application_gateway")

valid_app_gws[id] = app_gw {
    app_gw = app_gws[id]
    valid_app_gw(app_gw)
}

resource_type = "MULTIPLE"

policy[j] {
  app_gw = valid_app_gws[id]
  j = fugue.allow_resource(app_gw)
} {
  app_gw = app_gws[id]
  not valid_app_gws[id]
  j = fugue.deny_resource(app_gw)
}

