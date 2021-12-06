# Copyright 2021 Fugue, Inc.
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

package fugue.arm.postgresql_configuration_library

import data.fugue

servers = fugue.resources("Microsoft.DBforPostgreSQL/servers")

configurations = fugue.resources("Microsoft.DBforPostgreSQL/servers/configurations")

configuration_defaults := {
	"connection_throttling": "on",
	"log_checkpoints": "on",
	"log_connections": "on",
	"log_disconnections": "off",
	"log_duration": "off",
	"log_retention_days": "3",
}

configuration_by_server_id := {server_id: configuration |
	server := servers[server_id]
	configuration := {name: value |
		option := configurations[_]
		option._parent_id == server_id
		id_parts := split(option.id, "/")
		name := id_parts[count(id_parts) - 1]
		value := option.properties.value
	}
}

configuration_value(server, name) = ret {
	ret := configuration_by_server_id[server.id][name]
} else = ret {
	ret := configuration_defaults[name]
}
