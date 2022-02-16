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
package rules.tf_azurerm_sql_no_inbound_all

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_6.3"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_6.3"
      ]
    },
    "severity": "High"
  },
  "description": "Virtual Network security groups attached to SQL Server instances should not permit ingress from 0.0.0.0/0 to all ports and protocols. To reduce the potential attack surface for a SQL server, firewall rules should be defined with more granular IP addresses by referencing the range of addresses available from specific data centers.",
  "id": "FG_R00192",
  "title": "Virtual Network security groups attached to SQL Server instances should not permit ingress from 0.0.0.0/0 to all ports and protocols"
}

# An invalid range has start IP set to `0.0.0.0`; or end IP set to `0.0.0.0` or
# `255.255.255.255`
#
# NOTE: The Azure feature Allow access to Azure services can be enabled by
# setting start_ip_address and end_ip_address to 0.0.0.0 which (is documented in
# the Azure API Docs).  However, we also want to disallow that according to the
# CIS pdf so we don't really need a special case for it.

resource_type := "azurerm_sql_firewall_rule"

deny[info] {
  input.start_ip_address == "0.0.0.0"
  info := {"message": "start_ip_address should not be 0.0.0.0"}
} {
  input.end_ip_address == "0.0.0.0"
  info := {"message": "end_ip_address should not be 0.0.0.0"}
} {
  input.end_ip_address == "255.255.255.255"
  info := {"message": "end_ip_address should not be 255.255.255.255"}
}
