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
package rules.tf_aws_elb_access_log_enabled

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "Load balancer access logging should be enabled. Load balancer access logging should be enabled. Access logs record information about every HTTP and TCP request a load balancer processes. Access logging should be enabled in order to analyze statistics, diagnose issues, and retain data for regulatory or legal purposes.",
  "id": "FG_R00066",
  "title": "Load balancer access logging should be enabled"
}

elbs = fugue.resources("aws_elb")
lbs = fugue.resources("aws_lb")

all_resources[id] = resource {
  elbs[id] = resource
} {
  lbs[id] = resource
} {
  # Check that aws_alb is in the input. Should only be true in regula.
  fugue.input_resource_types["aws_alb"]
  fugue.resources("aws_alb")[id] = resource
}

access_logs_enabled(obj) {
  obj.access_logs[_].enabled == true
}

resource_type := "MULTIPLE"

policy[j] {
  obj = all_resources[_]
  access_logs_enabled(obj)
  j = fugue.allow_resource(obj)
} {
  obj = all_resources[_]
  not access_logs_enabled(obj)
  j = fugue.deny_resource(obj)
}
