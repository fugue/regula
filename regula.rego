package fugue.regula

import data.util.merge

# Grab resources from planned values.  Add "id" and "_type" keys.
planned_resources[id] = ret {
  resource = input.planned_values[_].resources[_]
  id = resource.address
  ret = merge.merge(resource.values, {"id": id, "_type": resource.type})
}

# Evaluate a single rule -- this can be either a single- or a multi-resource
# rule.
evaluate_rule(rule) = ret {
  pkg = rule["package"]
  resource_type = rule["resource_type"]
  resource_type != "MULTIPLE"

  denies = [ deny |
    resource = planned_resources[_]
    deny = data["rules"][pkg]["deny"] with input as resource
  ]

  ret = denies
} else = ret {
  # Note that `rule["resource_type"]` is not specified so we're dealing with a
  # multi-resource type validation.
  pkg = rule["package"]

  policy = data["rules"][pkg]["policy"] with input as {
    "resources": planned_resources
  }

  ret = policy
}

index(rules) = ret {
  ret = [evaluate_rule(rule) | rule = rules[_]]
}
