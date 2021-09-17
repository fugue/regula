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
package rules.tf_google_bigquery_no_public_access

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_7.1"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_7.1"
      ]
    },
    "severity": "Critical"
  },
  "description": "BigQuery datasets should not be anonymously or publicly accessible. BigQuery datasets should not grant the 'allUsers' or 'allAuthenticatedUsers' permissions because these will allow anyone to access the dataset and any stored sensitive data.",
  "id": "FG_R00437",
  "title": "BigQuery datasets should not be anonymously or publicly accessible"
}

resource_type = "google_bigquery_dataset"

anonymous_users = {"allAuthenticatedUsers", "allUsers"}

access_attributes = {"special_group", "iam_member"}

has_anonymous_access(ds) {
  access_attributes[k]
  member := ds.access[_][k]
  anonymous_users[member]
}

default deny = false

deny {
  has_anonymous_access(input)
}

