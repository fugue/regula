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
package rules.vpc_flow_log

import data.fugue

__rego__metadoc__ := {
  "id": "FG_R00054",
  "title": "VPC flow logging should be enabled",
  "description": "VPC flow logging should be enabled. AWS VPC Flow Logs provide visibility into network traffic that traverses the AWS VPC. Users can use the flow logs to detect anomalous traffic or insight during security workflows.",
  "custom": {
    "controls": {
      "CIS": [
        "CIS_2-9"
      ],
      "NIST": [
        "NIST-800-53_AC-4",
        "NIST-800-53_SC-7a",
        "NIST-800-53_SI-4a.2"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "MULTIPLE"

# every flow log in the template
flow_logs = fugue.resources("aws_flow_log")
# every VPC in the template
vpcs = fugue.resources("aws_vpc")

# VPC is valid if there is an associated flow log
is_valid_vpc(vpc) {
    vpc.id == flow_logs[_].vpc_id
}

policy[p] {
  resource = vpcs[_]
  not is_valid_vpc(resource)
  p = fugue.deny_resource(resource)
} {
  resource = vpcs[_]
  is_valid_vpc(resource)
  p = fugue.allow_resource(resource)
}
