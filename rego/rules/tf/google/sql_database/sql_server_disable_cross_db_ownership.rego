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
package rules.tf_google_sql_database_sql_server_disable_cross_db_ownership

import data.fugue
import data.google.sql_database.sql_database_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_6.3.1"
      ]
    },
    "severity": "Medium"
  },
  "description": "SQL Server database instance 'cross db ownership chaining' database flag should be set to 'off'. The SQL Server database instance flag 'cross db ownership chaining' allows you to control cross-database ownership chaining at the database level or to allow cross-database ownership chaining for all databases. This flag should be set to off unless all of the databases hosted on this instance must participate in cross-database ownership chaining and you are aware of the security implications of doing this.",
  "id": "FG_R00431",
  "title": "SQL Server database instance 'cross db ownership chaining' database flag should be set to 'off'"
}

resource_type = "MULTIPLE"

valid_db_instances[id] {
  db = lib.sql_server_database_instances[id]
  flag := lib.get_db_flag_with_default(db, "cross db ownership chaining", "on")
  flag == "off"
}

policy[j] {
  db = lib.sql_server_database_instances[id]
  valid_db_instances[id]
  j = fugue.allow_resource(db)
}

policy[j] {
  db = lib.sql_server_database_instances[id]
  not valid_db_instances[id]
  j = fugue.deny_resource(db)
}

