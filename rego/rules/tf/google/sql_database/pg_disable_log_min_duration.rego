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
package rules.tf_google_sql_database_pg_disable_log_min_duration

import data.fugue
import data.google.sql_database.sql_database_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.2.7"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_6.2.16"
      ]
    },
    "severity": "Medium"
  },
  "description": "PostgreSQL database instance 'log_min_duration_statement' database flag should be set to '-1' (disabled). The PostgreSQL database instance flag 'log_min_duration_statement' defines the minimum amount of execution time of a SQL statement in milliseconds where the total duration of the statement is logged. Ensure this flag is disabled by setting it to -1. This means there will be no logging of SQL statements because some may include sensitive information that should be not be recorded in logs.",
  "id": "FG_R00430",
  "title": "PostgreSQL database instance 'log_min_duration_statement' database flag should be set to '-1' (disabled)"
}

resource_type = "MULTIPLE"

valid_db_instances[id] {
  db = lib.postgres_database_instances[id]
  flag := lib.get_db_flag_with_default(db, "log_min_duration_statement", "-1")
  flag == "-1"
}

policy[j] {
  db = lib.postgres_database_instances[id]
  valid_db_instances[id]
  j = fugue.allow_resource(db)
}

policy[j] {
  db = lib.postgres_database_instances[id]
  not valid_db_instances[id]
  j = fugue.deny_resource(db)
}

