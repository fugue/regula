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
package rules.tf_google_storage_not_public

import data.fugue
import data.google.storage.bucket_policy_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_5.1"
      ]
    },
    "severity": "Critical"
  },
  "description": "Storage buckets should not be anonymously or publicly accessible. Cloud Storage bucket permissions should not be configured to allow 'allUsers' or 'allAuthenticatedUsers' access. These permissions provides broad, public access, which can result in unknown or undesired data access.",
  "id": "FG_R00420",
  "title": "Storage buckets should not be anonymously or publicly accessible"
}

resource_type = "MULTIPLE"

buckets = fugue.resources("google_storage_bucket")

anonymous_users = {"allAuthenticatedUsers", "allUsers"}

has_public_access(bucket) {
  members = lib.members_for_bucket(bucket)
  count(members & anonymous_users) > 0
}

policy[j] {
  bucket = buckets[_]
  not has_public_access(bucket)
  j = fugue.allow_resource(bucket)
}

policy[j] {
  bucket = buckets[_]
  has_public_access(bucket)
  j = fugue.deny_resource(bucket)
}

