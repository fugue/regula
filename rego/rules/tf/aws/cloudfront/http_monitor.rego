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
package rules.tf_aws_cloudfront_http_monitor

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "CloudFront distributions should be protected by WAFs. WAF should be deployed on CloudFront distributions to protect web applications from common web exploits that could affect application availability, compromise security, or consume excessive resources.",
  "id": "FG_R00073",
  "title": "CloudFront distributions should be protected by WAFs"
}

cloudfronts = fugue.resources("aws_cloudfront_distribution")

wafv1_web_acls = fugue.resources("aws_waf_web_acl")
wafv2_web_acls = fugue.resources("aws_wafv2_web_acl")

# WAFv1 ACLs are referenced by ID, while WAFv2 ACLs are referenced by ARN
wafv1_web_acl_ids = {id | id = wafv1_web_acls[_].id}
wafv2_web_acl_arns = {arn | arn = wafv2_web_acls[_].arn}

has_web_acl(cf) {
    wafv1_web_acl_ids[cf.web_acl_id]
} {
    wafv2_web_acl_arns[cf.web_acl_id]
}

resource_type = "MULTIPLE"

policy[j] {
  cf = cloudfronts[_]
  has_web_acl(cf)
  j = fugue.allow_resource(cf)
} {
  cf = cloudfronts[_]
  not has_web_acl(cf)
  j = fugue.deny_resource(cf)
}

