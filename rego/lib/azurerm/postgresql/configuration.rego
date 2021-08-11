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
package azurerm.postgresql.configuration

import data.fugue

configuration_sets = fugue.resources("azurerm_postgresql_configuration_set")

configurations_by_server_name := {server_name: configs |
  fugue.resource_types_v0["azurerm_postgresql_configuration"]
  configurations := fugue.resources("azurerm_postgresql_configuration")
  server_name := lower(configurations[_].server_name)
  configs := [c |
    c := configurations[_]
    lower(c.server_name) == lower(server_name)
  ]
}

# Run time
configuration_value(server, key) = value {
  configuration_set = configuration_sets[_]
  lower(configuration_set.server_name) == lower(server.name)
  value = configuration_set.config_map[key]
}

# Design time
configuration_value(server, key) = value {
  server_configs := [config |
    config := configurations_by_server_name[lower(server.name)][_]
    lower(config.name) == lower(key)
  ]
  value := server_configs[0].value
}

