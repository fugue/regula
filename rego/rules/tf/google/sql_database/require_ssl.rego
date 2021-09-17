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
package rules.tf_google_sql_database_require_ssl

import data.google.sql_database.sql_database_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.4"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_6.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "SQL database instances should require incoming connections to use SSL. SQL database instances supporting plaintext connections are susceptible to man-in-the-middle attacks that can reveal sensitive data like credentials, queries, and datasets. It is therefore recommended to always use SSL encryption for database connections.",
  "id": "FG_R00433",
  "title": "SQL database instances should require incoming connections to use SSL"
}

resource_type = "google_sql_database_instance"

default allow = false

allow {
  input.settings[_].ip_configuration[_].require_ssl == true
}

