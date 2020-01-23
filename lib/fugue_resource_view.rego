# This module is responsible for taking the raw output of terraform plan (the
# input to regula) and converting it to a structure that is easier to work with.
package fugue.resource_view

import data.util.merge
import data.util.resolve

# In our final resource view available to the rules, we merge an optional
# `configuration_resources` and `planned_values_resources` with a bias for
# `planned_values_resources`.
resource_view[id] = ret {
  planned_values_resource = planned_values_resources[id]
  configuration_resource = {k: v | r = configuration_resources[id]; r[k] = v}
  ret = merge.merge(configuration_resource, planned_values_resource)
}

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
  vars = {k: ref |
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
configuration_resources = ret {
  # Make sure output variables are resolved first, since we end up with a global
  # map of qualified names.
  outputs := resolve.resolve(configuration_module_outputs)

  ret := {qualified_address: resolved_references |
    configuration_modules[module_path] = [vars, module]
    resource = module.resources[_]
    qualified_address = module_qualify(module_path, resource.address)
    resolved_references = {key: resolved |
      expr = resource.expressions[key]
      is_object(expr)
      refs = expr.references
      count(refs) == 1
      ref = refs[0]
      resolved = configuration_resolve_ref(outputs, module_path, vars, ref)
    }
  }
}

# Resolve a reference inside a a configuration resource.
configuration_resolve_ref(outputs, module_path, vars, ref) = ret {
  # A variable that then references an output.
  startswith(ref, "var.")
  ret = outputs[vars[substring(ref, 4, -1)]]
} else = ret {
  # A variable that doesn't reference an output.
  startswith(ref, "var.")
  ret = vars[substring(ref, 4, -1)]
} else = ret {
  # A reference to an output.  Needs to be qualified before we look in
  # `outputs`.
  qual = module_qualify(module_path, ref)
  ret = outputs[qual]
} else = ret {
  # A local resource.
  ret = module_qualify(module_path, ref)
}
