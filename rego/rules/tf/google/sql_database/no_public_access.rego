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
package rules.tf_google_sql_database_no_public_access

import data.google.sql_database.sql_database_library as lib

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.5"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_6.5"
      ]
    },
    "severity": "High"
  },
  "description": "SQL database instances should not permit access from 0.0.0.0/0. SQL database instances permitting access from 0.0.0.0/0 are allowing access from anywhere in the world. To minimize its attack surface, a database server should only permit connections from trusted IP addresses.",
  "id": "FG_R00434",
  "title": "SQL database instances should not permit access from 0.0.0.0/0"
}

resource_type := "google_sql_database_instance"

default deny = false

deny {
  input.settings[_].ip_configuration[_].authorized_networks[_].value == "0.0.0.0/0"
}
