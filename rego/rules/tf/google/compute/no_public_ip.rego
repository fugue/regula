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
package rules.tf_google_compute_no_public_ip

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.9"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_4.9"
      ]
    },
    "severity": "Medium"
  },
  "description": "Compute instances should not have public IP addresses. Compute Engine instances should not have public IP addresses to reduce potential attack surfaces, as public IPs enable direct access via the internet. Instances serving internet traffic should be configured behind load balancers, which provide an additional layer of security.",
  "id": "FG_R00419",
  "title": "Compute instances should not have public IP addresses"
}

resource_type := "google_compute_instance"

default deny = false

deny {
  count(input.network_interface[_].access_config) > 0
}
