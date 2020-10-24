# Copyright 2020 Fugue, Inc.
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
package rules.sql_server_firewall_no_inbound_all

__rego__metadoc__ := {
  "id": "FG_R00192",
  "title": "SQL Server firewall rules should not permit ingress from 0.0.0.0/0 to all ports and protocols",
  "description": "Virtual Network security groups attached to SQL Server instances should not permit ingress from 0.0.0.0/0 to all ports and protocols. To reduce the potential attack surface for a SQL server, firewall rules should be defined with more granular IP addresses by referencing the range of addresses available from specific data centers.",
  "custom": {
    "controls": {
      "CISAZURE": [
        "CISAZURE_6.3"
      ],
      "NIST": [
        "NIST-800-53_SC-7 (5)"
      ]
    },
    "severity": "High"
  }
}

resource_type = "azurerm_sql_firewall_rule"

default deny = false

# An invalid range has start IP set to `0.0.0.0`; or end IP set to `0.0.0.0` or
# `255.255.255.255`
#
# NOTE: The Azure feature 'Allow access to Azure services' can be enabled by
# setting start_ip_address and end_ip_address to 0.0.0.0.  However, the CIS Azure
# Foundations Benchmark recommends disallowing this

deny {
  input.start_ip_address == "0.0.0.0"
} {
  input.end_ip_address == "0.0.0.0"
} {
  input.end_ip_address == "255.255.255.255"
}
