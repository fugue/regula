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
package rules.tf_aws_rds_backup_retention_period

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "RDS instances should have backup retention periods configured. Retention periods for RDS backups should be configured according to business and regulatory needs. Backups should not be retained longer than is strictly necessary. When retention is properly configured, malicious individuals will be unable to retrieve data when it is no longer needed.",
  "id": "FG_R00107",
  "title": "RDS instances should have backup retention periods configured"
}

has_backup_retention_period(inst_or_cluster) {
  inst_or_cluster.backup_retention_period > 0
}

instances_or_clusters[id] = r {rs = fugue.resources("aws_db_instance"); r = rs[id]}
instances_or_clusters[id] = r {rs = fugue.resources("aws_rds_cluster"); r = rs[id]}

valid_instances_or_clusters[id] = instance_or_cluster {
  instance_or_cluster = instances_or_clusters[id]
  has_backup_retention_period(instance_or_cluster)
}

resource_type = "MULTIPLE"

policy[j] {
  valid_instances_or_clusters[id] = instance_or_cluster
  j = fugue.allow_resource(instance_or_cluster)
} {
  instances_or_clusters[id] = instance_or_cluster
  not valid_instances_or_clusters[id]
  j = fugue.deny_resource(instance_or_cluster)
}

