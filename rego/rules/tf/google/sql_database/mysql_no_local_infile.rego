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
package rules.tf_google_sql_database_mysql_no_local_infile

import data.fugue
import data.google.sql_database.sql_database_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.1.2"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_6.1.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "MySQL database instance 'local_infile' database flag should be set to 'off'. The MySQL database instance 'local_infile' flag controls server-side LOCAL capabilities for LOAD DATA statements. If permitted, clients can perform local data loading, which can be a security risk.",
  "id": "FG_R00423",
  "title": "MySQL database instance 'local_infile' database flag should be set to 'off'"
}

resource_type = "MULTIPLE"

valid_db_instances[id] {
  db = lib.mysql_database_instances[id]
  flag := lib.get_db_flag_with_default(db, "local_infile", "on")
  flag == "off"
}

policy[j] {
  db = lib.mysql_database_instances[id]
  valid_db_instances[id]
  j = fugue.allow_resource(db)
}

policy[j] {
  db = lib.mysql_database_instances[id]
  not valid_db_instances[id]
  j = fugue.allow_resource(db)
}

