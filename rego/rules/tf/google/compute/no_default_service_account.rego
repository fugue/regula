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
package rules.google_compute_no_default_service_account

import data.google.compute.compute_instance_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.1"
      ]
    },
    "severity": "Medium"
  },
  "description": "Compute instances should not use the default service account. The default Compute Engine service account has an \"Editor\" role, which allows read and write access to most Google Cloud services. To apply the principle of least privileges and mitigate the risk of a Compute Engine instance being compromised, create a new service account for an instance with only the necessary permissions assigned. Note that GKE-created instances should be exempted from this.",
  "id": "FG_R00411",
  "title": "Compute instances should not use the default service account"
}

resource_type = "google_compute_instance"

default deny = false

deny {
  sa = input.service_account[_]
  lib.is_default_service_account(sa)
}

