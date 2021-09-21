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
package rules.tf_aws_ec2_asg

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "Auto Scaling groups should span two or more availability zones. Auto Scaling groups that span two or more availability zones promote redundancy of data, which helps ensure availability and continuity during an adverse situation.",
  "id": "FG_R00014",
  "title": "Auto Scaling groups should span two or more availability zones"
}

autoscaling_groups = fugue.resources("aws_autoscaling_group")
subnets = fugue.resources("aws_subnet")

az_by_subnet_id := {id: az |
  sub = subnets[_]
  id = sub.id
  az = sub.availability_zone
}

subnet_azs_by_asg_id := {id: azs |
  asg = autoscaling_groups[id]
  azs = {az |
    sub_id = asg.vpc_zone_identifier[_]
    az = az_by_subnet_id[sub_id]
  }
}

valid_autoscaling_group(asg) {
  azs = {az | az = asg.availability_zones[_]} 
  count(azs) >= 2
}

valid_autoscaling_group(asg) {
  count(subnet_azs_by_asg_id[asg.id]) >= 2
}

resource_type = "MULTIPLE"

policy[j] {
  asg = autoscaling_groups[_]
  valid_autoscaling_group(asg)
  j = fugue.allow_resource(asg)
} {
  asg = autoscaling_groups[_]
  not valid_autoscaling_group(asg)
  j = fugue.deny_resource(asg)
}

