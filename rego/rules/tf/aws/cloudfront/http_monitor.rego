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

resource_type = "aws_cloudfront_distribution"

default allow = false

allow {
  input.web_acl_id != ""
}

