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
package fugue.scan_view

import data.fugue
import data.fugue.input_type_internal
import data.fugue.regula
import data.fugue.resource_view

# Create a rule-resource result from a judgement
rule_resource_scan_result(rule, judgement) = ret {
  ret = {
    "provider": judgement.provider,
    "resource_id": judgement.id,
    "resource_type": judgement.type,
    "rule_enabled": rule.enabled,
    "rule_message": judgement.message,
    "rule_result": regula.result_string(judgement),
    "rule_name": rule["package"],
    "rule_valid": judgement.valid,
    # gets patched to true when waivers are applied
    "rule_waived": false,
    "filepath": judgement.filepath,
    "input_type": input_type_internal.input_type,
    "rule_id": rule.metadata.id,
    "rule_summary": rule.metadata.summary,
    "rule_description": rule.metadata.description,
    "rule_severity": rule.metadata.severity,
    "controls": rule.metadata.controls,
  }
}

# Evaluate a single rule -- this can be either a single- or a multi-resource
# rule.
evaluate_scan_rule(rule) = ret {
  pkg = rule["package"]
  resource_type = rule["resource_type"]
  resource_type != "MULTIPLE"

  judgements = {j |
    resource = resource_view.resource_view[_]
    resource._type == resource_type
    j = regula.evaluate_rule_judgements(pkg, resource)[_]
  }

  ret = [r | r = rule_resource_scan_result(rule, judgements[_])]
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

  judgements = regula.judgements_from_policies(policies)
  ret = [r | r = rule_resource_scan_result(rule, judgements[_])]
}

# The full report.
scan_single_report := ret {
  # We look at all packages inside `data.rules` that have a `resource_type`
  # declared and construct a list of rules based on that.
  #
  # We filter down the applicable rules by input kind.
  rules = [rule |
    resource_type = data.rules[pkg].resource_type
    rule_input_type = input_type_internal.rule_input_type(pkg)
    input_type_internal.compatibility[rule_input_type][input_type_internal.input_type]
    metadata = regula.rule_metadata(pkg)
    rule = {
      "package": pkg,
      "input_type": rule_input_type,
      "resource_type": resource_type,
      "metadata": metadata,
      "enabled": rule_enabled(metadata.id, pkg),
    }
  ]

  # Evaluate all these rules.
  rule_results = [r | r = evaluate_scan_rule(rules[_])[_]]

  # Produce the report.
  ret = {
    "rule_results": rule_results,
    "summary": regula.report_summary(rule_results),
  }
}

# Apply a waiver to a rule result
waiver_patch_rule_waived(rule_result) = ret {
  regula.waiver_matches_rule_result(rule_result)
  ret := json.patch(rule_result,
    [{"op": "add", "path": "rule_waived", "value": true}]
  )
} else = ret {
  ret := rule_result
}

# Update a report with waivers.  Should be processed as late possible, since
# we want filepaths to be set.
waiver_patch_scan_view(report0) = ret {
  rule_results := [waiver_patch_rule_waived(rr) | rr := report0.rule_results[_]]
  ret := {
    "rule_results": rule_results,
    "summary": regula.report_summary(rule_results),
  }
}

rule_enabled(rule_id, pkg) = true {
  not regula.disabled_rule_ids[rule_id]
  not regula.disabled_rule_names[pkg]
} else = false {
  true
}

# This is the final report.
# We either produce a merged report out of several files, or a single report.
scan_report = ret {
  is_array(input)
  merged := regula.merge_reports([report_1 |
    item := input[_]
    k := item.filepath
    report_0 := scan_single_report with input as item.content
    report_1 := regula.report_add_filepath(report_0, item.filepath)
  ])
  ret := waiver_patch_scan_view(merged)
} else = ret {
  ret := waiver_patch_scan_view(scan_single_report)
}

scan_view = ret {
  ret := {
    "scan_view_version": "v1",
    "report": scan_report,
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
