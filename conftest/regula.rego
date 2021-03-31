# Copyright 2020 Fugue, Inc.
# Copyright 2020 Jason Antman
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

# Conftest integration package for Regula.
package main

import data.fugue.regula

deny[{"msg": msg, "rule_name": rule_name, "resource": resource}] {
  # Our information comes from the report.  We select all invalid resources
  # and will generate a deny message for each of them.
  rule_result := regula.report.rule_results[_]
  rule_result.rule_result == "FAIL"

  rule_name := rule_result.rule_name
  resource := rule_result.resource_id
  best_message := best_rule_message(rule_result)

  msg := sprintf("regula: %s: %s: %s", [rule_name, resource, best_message])
}

best_rule_message(rule_result) = ret {
  ret := rule_result.rule_message
  ret != ""
} else = ret {
  ret := rule_result.rule_summary
} else = ret {
  ret := rule_result.rule_description
} else = "(no message)" {
  true
}
