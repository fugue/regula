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
package rules.tf_google_compute_proxy_ssl_policy

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_3.9"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_3.9"
      ]
    },
    "severity": "Medium"
  },
  "description": "Load balancer HTTPS or SSL proxy SSL policies should not have weak cipher suites. The default SSL policy for load balancers uses a minimum TLS version of 1.0 and a Compatible profile, which allows the widest range of insecure cipher suites. The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology, and older versions may pose security risks.",
  "id": "FG_R00410",
  "title": "Load balancer HTTPS or SSL proxy SSL policies should not have weak cipher suites"
}

resource_type = "MULTIPLE"

ssl_policies = fugue.resources("google_compute_ssl_policy")
proxies[id] = ret {
  ret = fugue.resources("google_compute_target_https_proxy")[id]
} {
  ret = fugue.resources("google_compute_target_ssl_proxy")[id]
}

invalid_tls_versions = {"TLS_1_0", "TLS_1_1"}
invalid_features = {
  "TLS_RSA_WITH_3DES_EDE_CBC_SHA",
  "TLS_RSA_WITH_AES_128_CBC_SHA",
  "TLS_RSA_WITH_AES_128_GCM_SHA256",
  "TLS_RSA_WITH_AES_256_CBC_SHA",
  "TLS_RSA_WITH_AES_256_GCM_SHA384"
}

policy_identifier(pol) = ret {
  ret := pol.self_link
} else = ret {
  ret := pol.id
}

invalid_ssl_policies[id] {
  ssl_policy = ssl_policies[_]
  ssl_policy.profile == "MODERN"
  invalid_tls_versions[ssl_policy.min_tls_version]
  id = policy_identifier(ssl_policy)
} {
  ssl_policy = ssl_policies[_]
  ssl_policy.profile == "CUSTOM"
  features = array.concat(
    object.get(ssl_policy, "enabled_features", []),
    object.get(ssl_policy, "custom_features", []),
  )
  invalid_features[features[_]]
  id = policy_identifier(ssl_policy)
}

policy[j] {
  proxy = proxies[_]
  not proxy.ssl_policy
  j = fugue.deny_resource(proxy)
} {
  proxy = proxies[_]
  invalid_ssl_policies[proxy.ssl_policy]
  j = fugue.deny_resource(proxy)
} {
  proxy = proxies[_]
  is_string(proxy.ssl_policy)
  not invalid_ssl_policies[proxy.ssl_policy]
  j = fugue.allow_resource(proxy)
}

