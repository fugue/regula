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
package google.sql_database.sql_database_library

import data.fugue

mysql_database_instances[id] = ret {
  databases = fugue.resources("google_sql_database_instance")
  database = databases[id]
  startswith(database.database_version, "MYSQL_")
  ret = database
}

postgres_database_instances[id] = ret {
  databases = fugue.resources("google_sql_database_instance")
  database = databases[id]
  startswith(database.database_version, "POSTGRES_")
  ret = database
}

sql_server_database_instances[id] = ret {
  databases = fugue.resources("google_sql_database_instance")
  database = databases[id]
  startswith(database.database_version, "SQLSERVER_")
  ret = database
}

get_db_flag_with_default(db_instance, flag_name, default_value) = ret {
  flag = db_instance.settings[_].database_flags[_]
  flag.name == flag_name
  ret = flag.value
} else = ret {
  ret = default_value
}
