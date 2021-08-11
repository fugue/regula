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
package rules.tf_google_sql_database_automated_backups

import data.google.sql_database.sql_database_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.7"
      ]
    },
    "severity": "Medium"
  },
  "description": "SQL database instance automated backups should be enabled. SQL database instances should be configured to be automatically backed up. Backups enable a Cloud SQL instance to recover lost data or to recover from a problem with that instance.",
  "id": "FG_R00436",
  "title": "SQL database instance automated backups should be enabled"
}

resource_type = "google_sql_database_instance"

default allow = false

allow {
  input.settings[_].backup_configuration[_].enabled == true
}

