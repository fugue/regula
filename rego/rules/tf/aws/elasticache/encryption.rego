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
package rules.tf_aws_elasticache_encryption

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_14.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "ElastiCache transport encryption should be enabled. In-transit encryption should be enabled for ElastiCache replication groups. Encryption protects data from unauthorized access when it is moved from one location to another, such as from a primary node to a read replica mode in a replication group or between a replication group and application.",
  "id": "FG_R00105",
  "title": "ElastiCache transport encryption should be enabled"
}

has_transport_encryption(repgroup) {
  repgroup.transit_encryption_enabled
}

repgroups = fugue.resources("aws_elasticache_replication_group")

resource_type = "MULTIPLE"

policy[j] {
  repgroup = repgroups[_]
  has_transport_encryption(repgroup)
  j = fugue.allow_resource(repgroup)
} {
  repgroups[_] = repgroup
  not has_transport_encryption(repgroup)
  j = fugue.deny_resource(repgroup)
}

