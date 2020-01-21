package fugue.regula

import data.util.merge
import data.fugue

# Grab all modules inside the `planned_values` section.
planned_values_module_resources[path] = ret {
  walk(input.planned_values.root_module, [path, ret])
  planned_values_module_resources_walk_path(path)
}

# Is this path a valid reference to resources in the root or a submodule?
planned_values_module_resources_walk_path(path) {
  path == ["resources"]
} {
  # Paths to child modules will have the following shape:
  #
  #     ["child_modules", NUM, "child_modules", NUM, "resources"]
  #
  # so we could do further checks here to make sure we are correct (odd
  # indices must be numbers, etc).
  len = count(path)
  len >= 3
  path[len - 1] == "resources"
  is_number(path[len - 2])
  path[len - 3] == "child_modules"
}

# Grab resources from planned values.  Add "id" and "_type" keys.
planned_values_resources[id] = ret {
  planned_values_module_resources[_] = resource_section
  resource = resource_section[_]
  id = resource.address
  ret = merge.merge(resource.values, {"id": id, "_type": resource.type})
}

# Grab all modules inside the `configuration` section.
configuration_modules[module_path] = ret {
  walk(input.configuration, [path, val])
  # Paths to the child modules here will have the following shape:
  #
  #     [..., "module_calls", CHILD_NAME, "module"]
  #
  # Just as in `planned_values_module_resources_walk_path`, there are probably
  # some more constraints that we can enforce below.
  is_object(val)
  module = val[module_name]
  is_object(module)
  _ = module.resources
  all([string_is_module_calls(k) | path[i] = k; i % 3 == 0])
  module_path = [k | path[i] = k; i % 3 == 2]

  # Calculate input variables used in this module.
  vars = {k: module_qualify(module_path, ref) |
     val.expressions[k].references = refs
     ref = refs[_]
  }

  ret = [vars, module]
}

# Utility to work around a fregot parsing bug.  Try inlining this and see what
# happens.
string_is_module_calls(k) {k == "module_calls"}

# Calculate outputs into a globally qualified map.
configuration_module_outputs[qualified_var] = qualified_val {
  configuration_modules[module_path] = [_, module]
  module.outputs[var].expression.references = refs
  count(refs) == 1
  val = refs[0]
  qualified_val = module_qualify(module_path, val)
  qualified_var = module_qualify(module_path, var)
}

# Qualify using a module path.
module_qualify(module_path, unqualified) = ret {
  module_path == []
  ret = unqualified
} else = ret {
  ret = concat(".", ["module", concat(".module.", module_path), unqualified])
}

# Grab resources from the configuration.  The only thing we're currently
# interested in are `references` to other resources.  You can find some more
# details about this format here:
# <https://www.terraform.io/docs/internals/json-format.html>.
configuration_resources[id] = ret {
  configuration_modules[_][1].resources = resource_section
  resource = resource_section[_]
  id = resource.address
  ret = {key: refs[0] |
    expr = resource.expressions[key]
    is_object(expr)
    refs = expr.references
    count(refs) == 1
  }
}

# In our final resource view available to the rules, we merge an optional
# `configuration_resources` and `planned_values_resources` with a bias for
# `planned_values_resources`.
resource_view[id] = ret {
  planned_values_resource = planned_values_resources[id]
  configuration_resource = {k: v | r = configuration_resources[id]; r[k] = v}
  ret = merge.merge(configuration_resource, planned_values_resource)
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
    resource = resource_view[_]
    resource._type == resource_type
    allows = [a | a = data["rules"][pkg]["allow"] with input as resource]
    denies = [d | d = data["rules"][pkg]["deny"]  with input as resource]
    j = judgement_from_allow_denies(resource, allows, denies)
  }

  ret = rule_report(pkg, judgements)
} else = ret {
  # Note that `rule["resource_type"]` is not specified so we're dealing with a
  # multi-resource type validation.
  pkg = rule["package"]

  # We're going to store the original input under `_plan`.
  plan = input

  policies = [ policy |
    policy = data["rules"][pkg]["policy"] with input as {
      "resources": resource_view,
      "_plan": plan
    }
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
      "controls": {c | data.rules[pkg].controls[c]}
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
    "summary": summary
  }
}
