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
package rules.tf_google_dns_dnssec_zone_signing_key


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_3.5"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_3.5"
      ]
    },
    "severity": "High"
  },
  "description": "DNS managed zone DNSSEC zone-signing keys should not use RSASHA1. Domain Name System Security Extensions (DNSSEC) algorithm numbers may be used in CERT RRs. Zone signing (DNSSEC) and transaction security mechanisms (SIG(0) and TSIG) make use of particular subsets of these algorithms. The zone-signing key algorithm should be strong, and RSASHA1 is no longer considered secure. Use it only for compatibility reasons.",
  "id": "FG_R00406",
  "title": "DNS managed zone DNSSEC zone-signing keys should not use RSASHA1"
}

resource_type = "google_dns_managed_zone"

invalid_algorithms = {"rsasha1"}

has_invalid_algorithm(dnssec_config) {
  key_spec := dnssec_config.default_key_specs[_]
  key_spec.key_type == "zoneSigning"
  invalid_algorithms[key_spec.algorithm]
}

default allow = false

allow {
  dnssec_config := input.dnssec_config[_]
  dnssec_config.state == "on"
  not has_invalid_algorithm(dnssec_config)
}

