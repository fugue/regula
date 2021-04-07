# Copyright 2020 Fugue, Inc.
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
package fugue.regula

import data.fugue
import data.fugue.input_type
import data.fugue.resource_view

# Construct a judgement using results from a single- resource rule.
judgement_from_allow_denies(resource, allows, denies) = ret {
  # Only `allow` is specified and the resource is valid.
  count(allows) > 0
  count(denies) <= 0
  all(allows)
  ret = fugue.allow_resource(resource)
} else = ret {
  # Only `allow` is specified and the resource is invalid.
  count(allows) > 0
  count(denies) <= 0
  not all(allows)
  ret = fugue.deny_resource(resource)
} else = ret {
  # Only `deny` is specified and the resource is valid.
  count(allows) <= 0
  count(denies) > 0
  not any(denies)
  ret = fugue.allow_resource(resource)
} else = ret {
  # Only `deny` is specified and the resource is invalid.
  count(allows) <= 0
  count(denies) > 0
  any(denies)
  ret = fugue.deny_resource(resource)
} else = ret {
  # Both `allow` and `deny` are specified and the resource is valid.
  count(allows) > 0
  count(denies) > 0
  all(allows)
  not any(denies)
  ret = fugue.allow_resource(resource)
} else = ret {
  # Both `allow` and `deny` are specified and the resource is invalid.  This is
  # the only remaining case so the body is very simple.
  count(allows) > 0
  count(denies) > 0
  ret = fugue.deny_resource(resource)
} else = ret {
  # Malformed single-resource rule.
  ret = {
    "error": "The rule does not specify allow or deny.",
    "valid": false
  }
}

# Construct judgements from simple `deny[msg]` style rules.
judgement_from_deny_messages(resource, messages) = ret {
  count(messages) == 0
  ret = fugue.allow_resource(resource)
} else = ret {
  msg = concat(", ", messages)
  ret = fugue.deny_resource_with_message(resource, msg)
}

# Construct judgements from a multi-resource rule that has a `policy` set.
judgements_from_policies(policies) = ret {
  count(policies) >= 0
  is_set(policies[0])
  ret = policies[0]
}

# Evaluate `allow` rules for a single resource.  This is a workaround for
# <https://github.com/open-policy-agent/opa/issues/2497>.
evaluate_allows(pkg, resource) = ret {
  ret = [a | a = data["rules"][pkg]["allow"] with input as resource]
}

# See `evaluate_allows`.
evaluate_denies(pkg, resource) = ret {
  ret = [a | a = data["rules"][pkg]["deny"] with input as resource]
}

# Evaluate the judgement for a simple rule.
evaluate_rule_judgement(pkg, resource) = ret {
  # Specifies `deny[msg]` as a set.
  denies = evaluate_denies(pkg, resource)
  any([is_set(d) | d = denies[_]])
  msgs = [msg | d = denies[_]; d[msg]]
  ret = judgement_from_deny_messages(resource, msgs)
} else = ret {
  # Specifies allow / deny as a boolean rule.
  allows = evaluate_allows(pkg, resource)
  denies = evaluate_denies(pkg, resource)
  ret = judgement_from_allow_denies(resource, allows, denies)
}

# Stringify judgement
result_string(judgement) = ret {
  judgement.valid == true
  ret = "PASS"
} else = ret {
  ret = "FAIL"
}

# Create a rule-resource result from a judgement
rule_resource_result(rule, judgement) = ret {
  ret = {
    "provider": judgement.provider,
    "resource_id": judgement.id,
    "resource_type": judgement.type,
    "rule_message": judgement.message,
    "rule_result": result_string(judgement),
    "rule_name": rule["package"],
    "platform": rule.input_type,
    "rule_id": rule.metadata.id,
    "rule_summary": rule.metadata.summary,
    "rule_description": rule.metadata.description,
    "rule_severity": rule.metadata.severity,
    "controls": rule.metadata.controls,
  }
}

# Evaluate a single rule -- this can be either a single- or a multi-resource
# rule.
evaluate_rule(rule) = ret {
  pkg = rule["package"]
  resource_type = rule["resource_type"]
  resource_type != "MULTIPLE"

  judgements = {j |
    resource = resource_view.resource_view[_]
    resource._type == resource_type
    j = evaluate_rule_judgement(pkg, resource)
  }

  ret = [r | r = rule_resource_result(rule, judgements[_])]
} else = ret {
  # Note that `rule["resource_type"]` is not specified so we're dealing with a
  # multi-resource type validation.
  pkg = rule["package"]

  # We're going to store the original input under `_plan`.
  plan = input

  policies = [ policy |
    policy = data["rules"][pkg]["policy"]
        with input as resource_view.resource_view_input
  ]

  judgements = judgements_from_policies(policies)
  ret = [r | r = rule_resource_result(rule, judgements[_])]
}

# Extract controls from custom block in rule metadoc
controls(custom) = ret {
  ret = { c | c = custom["controls"][_][_] }
} else = ret {
  ret = set()
}

# Transforms high -> High. Assumes input is a single word.
title_case(str) = ret {
  ret = concat("", [
    upper(substring(str, 0, 1)),
    lower(substring(str, 1, -1))
  ])
}

# Extract rule metadata from metadoc if it exists
rule_metadata(pkg) = ret {
  metadoc = object.get(data["rules"][pkg], "__rego__metadoc__", {})
  custom = object.get(metadoc, "custom", {})
  ret = {
    "description": object.get(metadoc, "description", ""),
    "id": object.get(metadoc, "id", ""),
    "summary": object.get(metadoc, "title", ""),
    "severity": title_case(object.get(custom, "severity", "Unknown")),
    "controls": controls(custom)
  }
}

# The full report.
single_report := ret {
  # We look at all packages inside `data.rules` that have a `resource_type`
  # declared and construct a list of rules based on that.
  #
  # We filter down the applicable rules by input kind.
  rules = [rule |
    resource_type = data.rules[pkg].resource_type
    rule_input_type = input_type.rule_input_type(pkg)
    rule_input_type == input_type.input_type
    rule = {
      "package": pkg,
      "input_type": rule_input_type,
      "resource_type": resource_type,
      "metadata": rule_metadata(pkg)
    }

    # Ignore disabled rules.
    not disabled_rule_ids[rule.metadata.id]
    not disabled_rule_names[rule["package"]]
  ]

  # Evaluate all these rules.
  rule_results = [r | r = evaluate_rule(rules[_])[_]]

  # Apply waivers.
  waived_rule_results := [waiver_patch_rule_result(r) | r := rule_results[_]]

  # Produce the report.
  ret = {
    "rule_results": waived_rule_results,
    "summary": report_summary(waived_rule_results),
  }
}

# Merge several reports together.
merge_reports(reports) = ret {
  rule_results := [rr | rr := reports[_].rule_results[_]]
  ret := {
    "rule_results": rule_results,
    # Recomputing is easier than summing but we could swap that out if we need
    # the performance.
    "summary": report_summary(rule_results),
  }
}

# Waiver globbing.
waiver_pattern_matches(pattern, value) {
  pattern == "*"
} {
  pattern == value
}

# Should a rule-resource result be waived?
waiver_matches_rule_result(rule_result) {
  waiver := data.fugue.regula.config.waivers[_]
  waiver_resource_id := object.get(waiver, "resource_id", "*")
  waiver_rule_id := object.get(waiver, "rule_id", "*")
  waiver_rule_name := object.get(waiver, "rule_name", "*")
  waiver_filename := object.get(waiver, "filename", "*")

  rule_result_filename := object.get(rule_result, "filename", null)

  waiver_pattern_matches(waiver_resource_id, rule_result.resource_id)
  waiver_pattern_matches(waiver_rule_id, rule_result.rule_id)
  waiver_pattern_matches(waiver_rule_name, rule_result.rule_name)
  waiver_pattern_matches(waiver_filename, rule_result_filename)
}

# Apply a waiver to a rule result
waiver_patch_rule_result(rule_result) = ret {
  waiver_matches_rule_result(rule_result)
  ret := json.patch(rule_result,
    [{"op": "add", "path": "rule_result", "value": "WAIVED"}]
  )
} else = ret {
  ret := rule_result
}

# Names of disabled rules.
disabled_rule_names := {rule.rule_name |
  rule := data.fugue.regula.config.rules[_]
  upper(rule.status) == "DISABLED"
}

# IDs of disabled rules.
disabled_rule_ids := {rule.rule_id |
  rule := data.fugue.regula.config.rules[_]
  upper(rule.status) == "DISABLED"
}

# Summarize a report.
report_summary(rule_results) = ret {
  all_severities := {"Critical", "High", "Medium", "Low", "Informational", "Unknown"}
  all_result_strings := {"PASS", "FAIL", "WAIVED"}
  all_filenames := {fn | fn := rule_results[_].filename}
  ret := {
    "filenames": [fn | fn := all_filenames[_]],
    "rule_results": {rs: total |
      rs := all_result_strings[_]
      total := count([r |
        r := rule_results[_]
        r.rule_result == rs
      ])
    },
    "severities": {s: total |
      s := all_severities[_]
      total := count([r |
        r = rule_results[_]
        r.rule_severity == s
        r.rule_result == "FAIL"
      ])
    },
  }
}

# Add filenames to a report.
report_add_filename(report_0, filename) = report_1 {
  report_1 := {
    "rule_results": [rule_result_1 |
      rule_result_0 := report_0.rule_results[_]
      rule_result_1 := json.patch(rule_result_0, [
        {"op": "add", "path": ["filename"], "value": filename}
      ])
    ],
    "summary": report_0.summary
  }
}

# This is the final report.
# We either produce a merged report out of several files, or a single report.
report = ret {
  is_array(input)
  ret := merge_reports([report_1 |
    item := input[_]
    k := item.filename
    report_0 := single_report with input as item.content
    report_1 := report_add_filename(report_0, item.filename)
  ])
} else = ret {
  ret := single_report
}
