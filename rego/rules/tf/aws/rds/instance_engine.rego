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
package rules.tf_aws_rds_instance_engine

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "Low"
  },
  "description": "RDS instances should have FedRAMP approved database engines. FedRAMP-approved database engines such as MySQL and PostgresQL satisfy strict U.S. government requirements for securing sensitive data. An RDS instance should use an approved database engine.",
  "id": "FG_R00094",
  "title": "RDS instances should have FedRAMP approved database engines"
}

instances = fugue.resources("aws_db_instance")

resource_type := "MULTIPLE"

policy[j] {
  i = instances[_]
  supported[i.engine]
  j = fugue.allow_resource(i)
} {
  i = instances[_]
  not supported[i.engine]
  j = fugue.deny_resource(i)
}

# Known FedRAMP engines as of 06/10/2020
# https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html
supported = {
  "aurora (for MySQL 5.6-compatible Aurora)",
  "aurora-mysql (for MySQL 5.7-compatible Aurora)",
  "aurora-postgresql",
  "mariadb",
  "mysql",
  "oracle-ee",
  "oracle-se2",
  "oracle-se1",
  "oracle-se",
  "postgres",
  "sqlserver-ee",
  "sqlserver-se",
  "sqlserver-ex",
  "sqlserver-web"
}
