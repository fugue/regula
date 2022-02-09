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

package rules.arm_app_service_min_tls_version

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_9.3"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_9.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "The TLS (Transport Layer Security) protocol secures transmission of data over the internet using standard encryption technology. Encryption should be set with the latest version of TLS. App service allows TLS 1.2 by default, which is the recommended TLS level by industry standards.",
  "id": "FG_R00347",
  "title": "App Service web apps should have 'Minimum TLS Version' set to '1.2'"
}

input_type := "arm"

resource_type := "MULTIPLE"

sites := fugue.resources("Microsoft.Web/sites")
configs := fugue.resources("Microsoft.Web/sites/config")

min_tls_version := parse_version("1.2")

parse_version(str) = ret {
  ret := [to_number(p) | p = regex.find_n(`[0-9]+`, str, -1)[_]]
}

valid_via_config := {id |
	c := configs[_]
	c.name == "web"
	parsed := parse_version(c.properties.minTlsVersion)
	parsed >= min_tls_version
	id := c._parent_id
	sites[id]
}

valid_via_property := {id |
	s := sites[id]
	parsed := parse_version(s.properties.siteConfig.minTlsVersion)
	parsed >= min_tls_version
}

valid_sites := valid_via_config | valid_via_property

policy[p] {
	s := sites[id]
	valid_sites[id]
	p = fugue.allow_resource(s)
}

policy[p] {
	s := sites[id]
	not valid_sites[id]
	p = fugue.deny_resource(s)
}
