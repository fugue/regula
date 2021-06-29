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
package rules.tf_aws_cloudfront_origin

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "CloudFront distribution origin should be set to S3 or origin protocol policy should be set to https-only. CloudFront connections should be encrypted during transmission over networks that can be accessed by malicious individuals. If a CloudFront distribution uses a custom origin, CloudFront should only use HTTPS to communicate with it. This does not apply if the CloudFront distribution is configured to use S3 as origin.",
  "id": "FG_R00010",
  "title": "CloudFront distribution origin should be set to S3 or origin protocol policy should be set to https-only"
}

cloudfronts = fugue.resources("aws_cloudfront_distribution")

s3_domain_pattern = "s3(\\.[a-z\\-]+?-[0-9]+?){0,1}\\.amazonaws\\.com$"

valid_origin(cf) {
  re_match(s3_domain_pattern, cf.origin[_].domain_name)
} {
  cf.origin[_].custom_origin_config[_].origin_protocol_policy == "https-only"
} {
  fugue.input_type != "tf_runtime"
  fugue.resources("aws_s3_bucket")[cf.origin[_].domain_name]
}

resource_type = "MULTIPLE"

policy[j] {
  cf = cloudfronts[_]
  valid_origin(cf)
  j = fugue.allow_resource(cf)
} {
  cf = cloudfronts[_]
  not valid_origin(cf)
  j = fugue.deny_resource(cf)
}

