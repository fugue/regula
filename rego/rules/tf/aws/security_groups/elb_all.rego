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
package rules.tf_aws_security_groups_elb_all

import data.aws.security_groups.library
import data.fugue



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
  "description": "ELB listener security groups should not be set to TCP all. ELB security groups should permit access only to necessary ports to prevent access to potentially vulnerable services on other ports.",
  "id": "FG_R00102",
  "title": "ELB listener security groups should not be set to TCP all"
}

invalid_security_group(sg) {
  library.rule_all_ports(sg.ingress[_])
}

resource_type = "MULTIPLE"

policy[j] {
  sg = library.load_balancer_security_groups[_]
  invalid_security_group(sg)
  j = fugue.deny_resource(sg)
} {
  sg = library.load_balancer_security_groups[_]
  not invalid_security_group(sg)
  j = fugue.allow_resource(sg)
}

