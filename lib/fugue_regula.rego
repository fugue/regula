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

# Create a report for a rule.
rule_report(pkg, judgements) = ret {
  ret = {
    "resources": {j.id: j | judgements[j]},
    "valid": all([j.valid | judgements[j]]),
    "metadata": rule_metadata(pkg)
  }
}

rule_metadata(pkg) = ret {
  ret = data["rules"][pkg]["__rego__metadoc__"]
} else = ret {
  ret = {}
}

controls(pkg) = ret {
  metadata = rule_metadata(pkg)
  ret = { c | c = metadata["custom"]["controls"][_][_] }
} else = ret {
  ret = set()
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

  ret = rule_report(pkg, judgements)
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
  ret = rule_report(pkg, judgements)
}

# The full report.
report = ret {
  # We look at all packages inside `data.rules` that have a `resource_type`
  # declared and construct a list of rules based on that.
  rules = [rule |
    resource_type = data.rules[pkg].resource_type
    rule = {
      "package": pkg,
      "resource_type": resource_type,
      "controls": controls(pkg)
    }
  ]

  rules_by_control = {c: rs |
    rules[_].controls[c]
    rs = {rule["package"] | rule = rules[_]; rule.controls[c]}
  }

  # Evaluate all these rules.
  rule_results = {rule["package"]: evaluate_rule(rule) | rule = rules[_]}

  # Group rule results into control results.
  control_results = {control: control_result |
    pkgs = rules_by_control[control]
    control_result = {
      "valid": all([rule_results[pkg].valid | pkgs[pkg]]),
      "rules": pkgs
    }
  }

  # Create a summary as well.
  summary = {
    "valid": all([r.valid | r = rule_results[_]]),
    "rules_passed": count([r | r = rule_results[_]; r.valid]),
    "rules_failed": count([r | r = rule_results[_]; not r.valid]),
    "controls_passed": count([r | r = control_results[_]; r.valid]),
    "controls_failed": count([r | r = control_results[_]; not r.valid]),
  }

  # Produce the report.
  ret = {
    "controls": control_results,
    "rules": rule_results,
    "summary": summary,
    "message": report_message(summary, rule_results),
  }
}

# Summarize the rule_results into a textual message.
report_message(summary, rule_results) = ret {
  summary.valid
  ret = sprintf(
    "%d rules and %d controls passed!",
    [summary.rules_passed, summary.controls_passed]
  )
} {
  not summary.valid
  ret = concat("", [
    sprintf("%d rules passed, %d rules failed\n",
      [summary.rules_passed, summary.rules_failed]),
    sprintf("%d controls passed, %d controls failed\n",
      [summary.controls_passed, summary.controls_failed]),
    concat("", [msg |
      resource_result = rule_results[rule_name].resources[resource_name]
      resource_result.valid == false
      msg = report_rule_message(
        rule_name, resource_name, resource_result.message)
    ])
  ])
}

# Generate a textual message for a single failure.
report_rule_message(rule_name, resource_name, message) = ret {
  resource_name = ""
  message = ""
  ret = sprintf("Rule %s failed\n", [rule_name])
} else = ret {
  resource_name = ""
  ret = sprintf("Rule %s failed: %s\n", [rule_name, message])
} else = ret {
  message = ""
  ret = sprintf("Rule %s failed for resource %s\n", [rule_name, resource_name])
} else = ret {
  ret = sprintf("Rule %s failed for resource %s: %s\n",
    [rule_name, resource_name, message])
}
