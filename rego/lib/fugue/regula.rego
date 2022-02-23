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
import data.fugue.input_type_internal
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

# Construct judgements from simple `deny[msg]` or `deny[obj]` style rules.
judgements_from_deny_set(resource, infos) = ret {
  count(infos) == 0
  ret = [fugue.allow_resource(resource)]
} else = ret {
  all([is_string(info) | info := infos[_]])
  msg = concat(", ", infos)
  ret = [fugue.deny_resource_with_message(resource, msg)]
} else = ret {
  all([is_object(info) | info := infos[_]])
  ret := [fugue.deny(params) |
    info := infos[_]
    params := json.patch(info,
      [{"op": "add", "path": "resource", "value": resource}]
    )
  ]
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

# Evaluate the judgement for a simple rule.  This may return multiple
# judgements.
evaluate_rule_judgements(pkg, resource) = ret {
  # Specifies `deny[msg]` as a set.
  denies = evaluate_denies(pkg, resource)
  any([is_set(d) | d = denies[_]])
  infos = [info | d = denies[_]; d[info]]
  ret = judgements_from_deny_set(resource, infos)
} else = ret {
  # Specifies allow / deny as a boolean rule.
  allows = evaluate_allows(pkg, resource)
  denies = evaluate_denies(pkg, resource)
  ret = [judgement_from_allow_denies(resource, allows, denies)]
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
    "resource_tags": judgement.tags,
    "rule_message": judgement.message,
    "rule_result": result_string(judgement),
    "rule_raw_result": judgement.valid,
    "rule_name": rule["package"],
    "rule_id": rule.metadata.id,
    "rule_summary": rule.metadata.summary,
    "rule_description": rule.metadata.description,
    "rule_severity": rule.metadata.severity,
    "controls": rule.metadata.controls,
    "families": rule.metadata.families,
    "filepath": judgement.filepath,
    "input_type": input_type_internal.input_type,
    "rule_remediation_doc": rule.metadata.rule_remediation_doc,
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
    j = evaluate_rule_judgements(pkg, resource)[_]
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
}

families_from_controls(custom) = ret {
  ret = { f | custom["controls"][f] }
}

families_from_families(custom) = ret {
  ret = { f | f = custom["families"][_] }
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
    "controls": controls(custom),
    "families": families_from_controls(custom) | families_from_families(custom),
    "rule_remediation_doc": object.get(custom, "rule_remediation_doc", "")
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
    rule_input_type = input_type_internal.rule_input_type(pkg)
    input_type_internal.compatibility[rule_input_type][input_type_internal.input_type]
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

  # Produce the report.
  ret = {
    "rule_results": rule_results,
    "summary": report_summary(rule_results),
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
  count(waiver) > 0  # Filter out completely empty waiver objects.
  waiver_resource_id := object.get(waiver, "resource_id", "*")
  waiver_resource_type := object.get(waiver, "resource_type", "*")
  waiver_rule_id := object.get(waiver, "rule_id", "*")
  waiver_rule_name := object.get(waiver, "rule_name", "*")
  waiver_filepath := object.get(waiver, "filepath", "*")

  rule_result_filepath := object.get(rule_result, "filepath", null)

  waiver_pattern_matches(waiver_resource_id, rule_result.resource_id)
  waiver_pattern_matches(waiver_resource_type, rule_result.resource_type)
  waiver_pattern_matches(waiver_rule_id, rule_result.rule_id)
  waiver_pattern_matches(waiver_rule_name, rule_result.rule_name)
  waiver_pattern_matches(waiver_filepath, rule_result_filepath)
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

# Update a report with waivers.  Should be processed as late possible, since
# we want filepaths to be set.
waiver_patch_report(report0) = ret {
  rule_results := [waiver_patch_rule_result(rr) | rr := report0.rule_results[_]]
  ret := {
    "rule_results": rule_results,
    "summary": report_summary(rule_results),
  }
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
  all_filepaths := {fn | fn := rule_results[_].filepath}
  ret := {
    "filepaths": [fn | fn := all_filepaths[_]],
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

# Add filepaths to a report.
report_add_filepath(report_0, filepath) = report_1 {
  report_1 := {
    "rule_results": array.concat(
      [rule_result_1 |
        rule_result_0 := report_0.rule_results[_]
        rule_result_0.filepath == ""
        rule_result_1 := json.patch(rule_result_0, [
          {"op": "add", "path": ["filepath"], "value": filepath}
        ])
      ],
      [rule_result_1 |
        rule_result_0 := report_0.rule_results[_]
        rule_result_0.filepath != ""
        rule_result_1 := rule_result_0
      ]),
    "summary": report_0.summary
  }
}

# This is the final report.
# We either produce a merged report out of several files, or a single report.
report = ret {
  is_array(input)
  merged := merge_reports([report_1 |
    item := input[_]
    k := item.filepath
    report_0 := single_report with input as item.content
    report_1 := report_add_filepath(report_0, item.filepath)
  ])
  ret := waiver_patch_report(merged)
} else = ret {
  ret := waiver_patch_report(single_report)
}

scan_view = ret {
  ret := {
    "scan_view_version": "v1",
    "report": report,
    "inputs": [input_resources |
      item := input[_]
      r := resource_view.resource_view_input.resources with input as item.content
      t := input_type_internal.input_type with input as item.content
      input_resources = {
        "filepath": item.filepath,
        "input_type": t,
        "resources": r,
      }
    ]
  }
}
