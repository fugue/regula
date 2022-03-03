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
package rules.tf_aws_rds_multi_az

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Require Multi Availability Zones turned on for RDS Instances. Provisioning multi-AZ RDS instances provides enhanced availability and durability in case of AZ failure.",
  "id": "FG_R00251",
  "title": "Require Multi Availability Zones turned on for RDS Instances"
}

db_instances = fugue.resources("aws_db_instance")

# Validate instances.  They can be invalid for a number of reasons; the relevant
# reason is returned.

bad_instance(dbi) = "The RDS database engine must support multiple availability zones." {
  multi_az_supported_engines = {
    "mariadb",
    "mysql",
    "oracle-ee",
    "oracle-se1",
    "oracle-se2",
    "oracle-se",
    "postgres"
  }
  not multi_az_supported_engines[dbi.engine]
} else = "Multi-AZ must be enabled for the DB instance." {
  not dbi.multi_az
}

resource_type := "MULTIPLE"

policy[j] {
  dbi = db_instances[_]
  reason = bad_instance(dbi)
  j = fugue.deny_resource_with_message(dbi, reason)
} {
  dbi = db_instances[_]
  not bad_instance(dbi)
  j = fugue.allow_resource(dbi)
}
