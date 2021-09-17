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
package rules.tf_google_storage_uniform_access


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_5.2"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_5.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "Storage bucket uniform access control should be enabled. Permissions for Cloud Storage can be granted using Cloud IAM or ACLs. Cloud IAM allows permissions at the bucket and project levels, whereas ACLs are only used by Cloud Storage, but allow per-object permissions. Uniform bucket-level access disables ACLs, which ensures that only Cloud IAM is used for permissions. This ensures that bucket-level and/or project-level permissions will be the same as object-level permissions.",
  "id": "FG_R00421",
  "title": "Storage bucket uniform access control should be enabled"
}

resource_type = "google_storage_bucket"

default allow = false

allow {
  input.uniform_bucket_level_access == true
}

