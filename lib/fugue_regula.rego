package fugue.regula

import data.util.merge
import data.fugue

# Grab resources from planned values.  Add "id" and "_type" keys.
planned_resources[id] = ret {
  resource = input.planned_values[_].resources[_]
  id = resource.address
  ret = merge.merge(resource.values, {"id": id, "_type": resource.type})
}

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

# Construct judgements from a multi-resource rule that has a `policy` set.
judgements_from_policies(policies) = ret {
  count(policies) >= 0
  is_set(policies[0])
  ret = policies[0]
}

# Create a report for a rule.
rule_report(pkg, judgements) = ret {
  ret = {
    "package": pkg,
    "resources": {j.id: j | judgements[j]},
    "valid": all([j.valid | judgements[j]])
  }
}

# Evaluate a single rule -- this can be either a single- or a multi-resource
# rule.
evaluate_rule(rule) = ret {
  pkg = rule["package"]
  resource_type = rule["resource_type"]
  resource_type != "MULTIPLE"

  judgements = { j |
    resource = planned_resources[_]
    allows = [a | a = data["rules"][pkg]["allow"] with input as resource]
    denies = [d | d = data["rules"][pkg]["deny"]  with input as resource]
    j = judgement_from_allow_denies(resource, allows, denies)
  }

  ret = rule_report(pkg, judgements)
} else = ret {
  # Note that `rule["resource_type"]` is not specified so we're dealing with a
  # multi-resource type validation.
  pkg = rule["package"]

  policies = [ policy |
    policy = data["rules"][pkg]["policy"] with input as {
      "resources": planned_resources
    }
  ]

  judgements = judgements_from_policies(policies)
  ret = rule_report(pkg, judgements)
}

# The full report.
report = ret {
  # We look at all packages inside `data.rules` that have a `resource_type`
  # declared and construct a list of rules based on that.
  rules = [ rule |
    resource_type = data["rules"][pkg]["resource_type"]
    rule = {
      "package": pkg,
      "resource_type": resource_type
    }
  ]

  # Evaluate all these rules.
  results = {rule["package"]: evaluate_rule(rule) | rule = rules[_]}

  # Produce the report.
  ret = {
    "rules": results,
    "passed": [pkg | r = results[_]; r.valid; pkg = r["package"]],
    "failed": [pkg | r = results[_]; not r.valid; pkg = r["package"]],
    "num_passed": count([r | r = results[_]; r.valid]),
    "num_failed": count([r | r = results[_]; not r.valid]),
    "valid": all([r.valid | r = results[_]])
  }
}
