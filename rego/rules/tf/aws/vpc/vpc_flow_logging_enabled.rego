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
package rules.tf_aws_vpc_vpc_flow_logging_enabled

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_2.9"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_3.9"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_3.9"
      ]
    },
    "severity": "Medium"
  },
  "description": "VPC flow logging should be enabled. AWS VPC Flow Logs provide visibility into network traffic that traverses the AWS VPC. Users can use the flow logs to detect anomalous traffic or insight during security workflows.",
  "id": "FG_R00054",
  "title": "VPC flow logging should be enabled"
}

vpcs = fugue.resources("aws_vpc")

flow_logs = fugue.resources("aws_flow_log")

flow_log_vpc_ids = {vpc_id | vpc_id = flow_logs[_].vpc_id}

resource_type := "MULTIPLE"

policy[j] {
  vpc = vpcs[_]
  flow_log_vpc_ids[vpc.id]
  j = fugue.allow_resource(vpc)
} {
  vpc = vpcs[_]
  not flow_log_vpc_ids[vpc.id]
  j = fugue.deny_resource(vpc)
}
