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
  "description": "WAFv2 web ACLs should include the \u2018AWSManagedRulesKnownBadInputsRuleSet\u2019 managed rule group. The \u201cKnown bad inputs\u201d (AWSManagedRulesKnownBadInputsRuleSet) managed rule group contains rules that block request patterns that are invalid or known to be associated with vulnerabilities, such as Log4j. Please note that the \u201cLog4JRCE\u201d WAF rule (and many others) only inspects the first 8 KB of the request body, so you may additionally want to ensure that the \u201cCore rule set\u201d (AWSManagedRulesCommonRuleSet) is also included, as the \u201cSizeRestrictions_BODY\u201d rule in that managed rule group verifies that the request body size is at most 8 KB.",
  "id": "FG_R00500",
  "title": "WAFv2 web ACLs should include the \u2018AWSManagedRulesKnownBadInputsRuleSet\u2019 managed rule group"
}

wafsv2 = fugue.resources("aws_wafv2_web_acl")

resource_type = "MULTIPLE"

valid_rule_names = {"AWSManagedRulesKnownBadInputsRuleSet"}
valid_vendor_names = {"AWS"}
invalid_exclusions = {"Log4JRCE", "Log4JRCE_ALL_HEADER"}

is_valid_waf(waf) {
  rule = waf.rule[_]
  not rule_overridden(rule)

  managed_statement = waf.rule[_].statement[_].managed_rule_group_statement[_]
  valid_vendor_names[managed_statement.vendor_name]
  valid_rule_names[managed_statement.name]
  not excludes_log4jrce(managed_statement)
}

rule_overridden(rule) {
  count(rule.override_action[_].count) == 1
}

excludes_log4jrce(managed_statement) {
  invalid_exclusions[managed_statement.excluded_rule[_].name]
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

