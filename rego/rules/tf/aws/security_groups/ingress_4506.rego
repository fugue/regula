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
package rules.tf_aws_security_groups_ingress_4506

import data.aws.security_groups.library


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_12.4",
        "CIS-Controls_v7.1_9.2",
        "CIS-Controls_v7.1_9.4"
      ]
    },
    "severity": "High"
  },
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 4506 (SaltStack Master). Removing unfettered connectivity to a SaltStack Master server reduces its exposure to risk.",
  "id": "FG_R00263",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 4506 (SaltStack Master)"
}

resource_type = "aws_security_group"

default deny = false

deny {
  library.security_group_ingress_zero_cidr_to_port(input, 4506)
}

