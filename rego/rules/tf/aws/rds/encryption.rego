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
package rules.aws_rds_encryption

import data.aws.rds.encryption_library as lib
import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_14.8"
      ]
    },
    "severity": "High"
  },
  "description": "RDS instances should be encrypted (AWS-managed or customer-managed KMS CMKs). Encrypting your RDS DB instances provides an extra layer of security by securing your data from unauthorized access.",
  "id": "FG_R00093",
  "title": "RDS instances should be encrypted (AWS-managed or customer-managed KMS CMKs)"
}

resource_type = "MULTIPLE"

policy[j] {
  ioc = lib.instances_or_clusters[_]
  lib.is_encrypted(ioc)
  j = fugue.allow_resource(ioc)
} {
  ioc = lib.instances_or_clusters[_]
  not lib.is_encrypted(ioc)
  j = fugue.deny_resource(ioc)
}

