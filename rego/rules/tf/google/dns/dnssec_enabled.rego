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
package rules.tf_google_dns_dnssec_enabled

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_3.3"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_3.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "DNS managed zone DNSSEC should be enabled. Attackers can hijack the process of domain/IP lookup and redirect users to a malicious site. Domain Name System Security Extensions (DNSSEC) cryptographically signs DNS records and can help prevent attackers from issuing fake DNS responses that redirect browsers.",
  "id": "FG_R00404",
  "title": "DNS managed zone DNSSEC should be enabled"
}

resource_type := "google_dns_managed_zone"

default allow = false

allow {
  input.dnssec_config[_].state == "on"
}
