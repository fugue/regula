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
package rules.aws_cloudfront_geo_restrictions

import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "CloudFront distributions should have geo-restrictions specified. CloudFront distributions should enable geo-restriction when an organization needs to prevent users in specific geographic locations from accessing content. For example, if an organization has rights to distribute content in only one country, geo restriction should be enabled to allow access only from users in the whitelisted country. Or if the organization cannot distribute content in a particular country, geo restriction should deny access from users in the blacklisted country.",
  "id": "FG_R00018",
  "title": "CloudFront distributions should have geo-restrictions specified"
}

cloudfront_distributions = fugue.resources("aws_cloudfront_distribution")

valid_restriction_types = {"whitelist", "blacklist"}

valid_cloudfront_distribution(cd) {
  restriction_type = cd.restrictions[_].geo_restriction[_].restriction_type
  valid_restriction_types[restriction_type]
}

resource_type = "MULTIPLE"

policy[j] {
  cd = cloudfront_distributions[_]
  valid_cloudfront_distribution(cd)
  j = fugue.allow_resource(cd)
} {
  cd = cloudfront_distributions[_]
  not valid_cloudfront_distribution(cd)
  j = fugue.deny_resource(cd)
}

