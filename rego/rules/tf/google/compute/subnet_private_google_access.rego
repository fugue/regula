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

# VPC subnet 'Private Google Access' should be enabled.
# When enabled, VMs in this subnetwork without external IP addresses can
# access Google APIs and services by using Private Google Access.
package rules.tf_google_compute_subnet_private_google_access

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.0.0": [
        "CIS-Google_v1.0.0_3.8"
      ]
    },
    "severity": "Low"
  },
  "description": "Enabling \"Private Google Access\" for VPC subnets allows virtual machines to connect to the external IP addresses used by Google APIs and services.",
  "id": "FG_R00438",
  "title": "VPC subnet 'Private Google Access' should be enabled"
}

resource_type := "google_compute_subnetwork"

default allow = false

allow {
  input.private_ip_google_access == true
}
