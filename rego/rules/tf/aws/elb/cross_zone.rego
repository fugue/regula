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
package rules.aws_elb_cross_zone

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "ELBv1 load balancer cross zone load balancing should be enabled. Having Availability Zone with the Cross-Zone Load Balancing feature enabled for the VPC reduces the risk of failure at a single location as the AWS Elastic Load Balancers distribute the traffic to the other locations.",
  "id": "FG_R00043",
  "title": "ELBv1 load balancer cross zone load balancing should be enabled"
}

elbs = fugue.resources("aws_elb")

resource_type = "MULTIPLE"

policy[j] {
  elbs[_] = obj
  obj.cross_zone_load_balancing
  j = fugue.allow_resource(obj)
} {
  elbs[_] = obj
  not obj.cross_zone_load_balancing
  j = fugue.deny_resource(obj)
}

