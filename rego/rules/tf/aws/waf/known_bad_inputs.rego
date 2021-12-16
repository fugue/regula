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
package rules.tf_aws_waf_known_bad_inputs

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Critical"
  },
  "description": "Utilize the AWS WAF AWSManagedRulesKnownBadInputsRuleSetmanaged rule to protect against malicious input. Utilize the AWS WAF AWSManagedRulesKnownBadInputsRuleSetmanaged rule to protect against malicious input.",
  "id": "FG_R00500",
  "title": "Utilize the AWS WAF AWSManagedRulesKnownBadInputsRuleSetmanaged rule to protect against malicious input"
}

wafsv2 = fugue.resources("aws_wafv2_web_acl")

resource_type = "MULTIPLE"

valid_rule_names = {"AWSManagedRulesKnownBadInputsRuleSet"}
valid_vendor_names = {"AWS"}

is_valid_waf(waf) {
  managed_statement = waf.rule[_].statement[_].managed_rule_group_statement[_]

  valid_vendor_names[managed_statement.vendor_name]
  valid_rule_names[managed_statement.name]
}

policy[j] {
  fugue.input_type == "tf_runtime"
  count(wafsv2) == 0
  j = fugue.missing_resource("aws_wafv2_web_acl")
}

policy[j] {
  waf = wafsv2[_]
  is_valid_waf(waf)
  j = fugue.allow_resource(waf)
}

policy[j] {
  waf = wafsv2[_]
  not is_valid_waf(waf)
  j = fugue.deny_resource(waf)
}

