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
package rules.google_compute_no_default_service_account_with_scopes

import data.google.compute.compute_instance_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.2"
      ]
    },
    "severity": "High"
  },
  "description": "Compute instances should not use the default service account with full access to all Cloud APIs. If using the default Compute Engine service account (which is not recommended), note that the \"Editor\" role is assigned with three possible scopes: allow default access, allow full access to all Cloud APIs, and set access for each Cloud API. Avoid allowing the scope for full access to all Cloud APIs, as this may enable users accessing the Compute Engine instance to perform cloud operations outside the scope of responsibility, or increase the potential impact of a compromised instance. Note that GKE-created instances should be exempted from this.",
  "id": "FG_R00412",
  "title": "Compute instances should not use the default service account with full access to all Cloud APIs"
}

resource_type = "google_compute_instance"

default deny = false

invalid_scopes = {
  "https://www.googleapis.com/auth/cloud-platform",
  "cloud-platform"
}

deny {
  sa = input.service_account[_]
  lib.is_default_service_account(sa)
  invalid_scopes[sa.scopes[_]]
}

