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
package rules.tf_aws_elb_http_listener

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "ELBv1 listener protocol should not be set to http. Communication from an ELB to EC2 instances should be encrypted to help prevent unauthorized access to data. To protect data in transit, ELB listener protocol should not be set to HTTP.",
  "id": "FG_R00013",
  "title": "ELBv1 listener protocol should not be set to http"
}

elbs = fugue.resources("aws_elb")

# Valid if lb_protocol is anything other than "http"
elb_has_http(elb) {
  elb.listener[_].lb_protocol == "http"
}

resource_type := "MULTIPLE"

policy[j] {
  elb = elbs[_]
  elb_has_http(elb)
  j = fugue.deny_resource(elb)
} {
  elb = elbs[_]
  not elb_has_http(elb)
  j = fugue.allow_resource(elb)
}
