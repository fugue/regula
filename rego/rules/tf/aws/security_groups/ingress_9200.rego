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
package rules.tf_aws_security_groups_ingress_9200

import data.aws.security_groups.library
import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 9200 (Elasticsearch). Removing unfettered connectivity to an Elasticsearch server reduces the chance of exposing critical data.",
  "id": "FG_R00212",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 9200 (Elasticsearch)"
}

security_groups = fugue.resources("aws_security_group")

resource_type := "MULTIPLE"

policy[j] {
  sg = security_groups[_]
  library.security_group_ingress_zero_cidr_to_port(sg, 9200)
  j = fugue.deny_resource(sg)
} {
  sg = security_groups[_]
  not library.security_group_ingress_zero_cidr_to_port(sg, 9200)
  j = fugue.allow_resource(sg)
}
