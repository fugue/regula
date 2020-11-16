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

# This module is responsible for taking the raw output of terraform plan (the
# input to regula) and converting it to a structure that is easier to work with.
package fugue.resource_view

import data.util.merge
import data.util.update
import data.util.resolve

# This constructs the input for the rules, with most importantly the
# `resource_view` in `resources`.
resource_view_input = {
  "resources": resource_view,
  "_plan": input
}

# In our final resource view available to the rules, we merge optional
# `configuration_resources` into `planned_values_resources`.
resource_view[id] = ret {
  planned_values_resource := planned_values_resources[id]
  patches := object.get(resource_view_patches, id, [])
  ret := json.patch(planned_values_resource, patches)
}

# These are the patches applied to each resource in order to fill in
# unknown references.
resource_view_patches[id] = patches {
  _ := planned_values_resources[id]
  references := object.get(configuration_references, id, [])
  after_unknowns := object.get(resource_changes_unknowns, id, [])
  patches := [patch |
    # Obtain the paths from the unknown values.
    path = after_unknowns[_]

    # The references can be anything that is a _prefix_ of this path.
    [prefix, refs] := references[_]
    array.slice(path, 0, count(prefix)) == prefix
    count(prefix) > 0

    # Turn the value into a singleton if possible.
    value := reference_as_singleton_or_array(refs)

    # Create a patch that works with json.patch.
    patch := {"op": "add", "path": path, "value": value}
  ]

  _ = patches[_]
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

# Return an empty object for resources without values
resource_values(resource) = ret {
  ret = resource.values
} else {
  ret = {}
}

# Grab resources from planned values.  Add "id" and "_type" keys.
planned_values_resources[id] = ret {
  planned_values_module_resources[_] = resource_section
  resource = resource_section[_]
  id = resource.address
  ret = merge.merge(resource_values(resource), {"id": id, "_type": resource.type})
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
     count(refs) == 1
     ref = refs[0]
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

# Grab info from the configuration.  The only thing we're currently
# interested in are `references` to other resources.  You can find some more
# details about this format here:
# <https://www.terraform.io/docs/internals/json-format.html>.
#
# The returned value is an object that has the references for every resource.
# The references are represented as an array of tuples where the first element
# is the path to the key, and the second element are the references (or single
# reference).  For example:
#
#     {
#       "aws_iam_policy.example": [
#         [["policy"], "data.aws_iam_policy_document.example"]
#       ],
#       "data.aws_iam_policy_document.example": [
#         [["statement", 0, "resources"], "aws_s3_bucket.example"]
#       ]
#     }
#
configuration_references = ret {
  # Make sure output variables are resolved first, since we end up with a global
  # map of qualified names.
  outputs := resolve.resolve(configuration_module_outputs)

  ret := {qualified_address: resolved_references |
    configuration_modules[module_path] = [vars, module]
    resource = module.resources[_]
    qualified_address = module_qualify(module_path, resource.address)
    resolved_references = [[keys, resolved] |
      # Check recursively.
      [keys, value] = walk(resource.expressions)

      # Check shape.
      refs = value.references
      is_array(refs)
      all([is_string(ref) | ref = refs[_]])

      # Resolve and return.
      resolved = [
        configuration_resolve_ref(outputs, module_path, vars, ref) |
        ref = refs[_]
      ]
    ]

    # No need to return anything if the list is empty.
    _ = resolved_references[_]
  }
}

# We don't have the schemas available (currently) so we don't know if a
# reference is supposed to be a list or an single element.  We do a best-guess
# and the rules will need to take both cases into account.
reference_as_singleton_or_array(xs) = ret {
  count(xs) == 1
  ret = xs[0]
} {
  count(xs) > 1
  ret = xs
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
  not startswith(ref, "var.")
  qual = module_qualify(module_path, ref)
  ret = outputs[qual]
} else = ret {
  # A local resource.
  not startswith(ref, "var.")
  ret = module_qualify(module_path, ref)
}

# resource_changes_unknown collects the unknown paths from the
# `resource_changes` section of the plan.  This is used to know _where_ we
# can plug in the values obtained in `configuration_references`.
resource_changes_unknowns[address] = after_unknowns {
  resource_change := input.resource_changes[_]
  address := resource_change.address
  block := resource_change.change.after_unknown
  after_unknowns := [path |
    walk(block, [path, unknown])
    unknown == true
  ]
}
