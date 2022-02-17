# Copyright 2021 Fugue, Inc.
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
package fugue.resource_view.cloudformation

import data.fugue.resource_view.terraform

resource_view[id] = ret {
  resource := input.Resources[id]
  properties := rewrite_properties(object.get(resource, "Properties", {}))
  tags := properties_tags(properties)
  ret := json.patch(properties, [
    {"op": "add", "path": ["id"], "value": id},
    {"op": "add", "path": ["_type"], "value": resource.Type},
    {"op": "add", "path": ["_provider"], "value": "aws"},
    {"op": "add", "path": ["_tags"], "value": tags},
  ])
}

rewrite_properties(properties) = ret {
  patches := [p |
    walk(properties, [attr_path, attr_value])
    new_attribute := rewrite_attribute(attr_path, attr_value)
    p := {"op": "replace", "path": attr_path, "value": new_attribute}
  ]
  ret := json.patch(properties, patches)
}

param_value(param) = def {
  # Try the default first.
  def = input.Parameters[param].Default
} else = first {
  # Grab the first allowed value.
  first = input.Parameters[param].AllowedValues[0]
}

# Attempt to unreference a reference.  This can point to either a parameter or
# another resource (in which case we leave the ID as-is).
unref(ref) = val {
  val = param_value(ref)
} else = ref {
  true
}

rewrite_attribute(attr_path, attr_value) = ret {
  refs := attribute_references(attr_path, attr_value)
  count(refs) > 0
  ret := terraform.reference_as_singleton_or_array(refs)
}

attribute_references(attr_path, attr_value) = refs {
  # Joins are often tested; only consider the top level one.
  count([p | p := attr_path[_]; p == "Fn::Join"]) == 0
  attr_value = {"Fn::Join": [_, pieces]}
  refs := [ref |
    piece := pieces[_]
    walk(piece, [_, sub_attr_value])
    ref := attribute_references_1(sub_attr_value)[_]
  ]
} else = refs {
  # Do not do anything inside joins as that could conflict with the references
  # generated above.
  count([p | p := attr_path[_]; p == "Fn::Join"]) == 0
  refs := attribute_references_1(attr_value)
}

fn_sub_template_variables(template) = ret {
  matches := regex.find_all_string_submatch_n(`\$\{([:\w]+)[.:\w]*\}`, template, -1)
  ret := [arr[1] | arr = matches[_]]
}

attribute_references_1(attr) = ret {
  attr = {"Fn::GetAtt": [id, "Arn"]}
  ret := [id]
} else = ret {
  attr = {"Ref": ref}
  ret := [unref(ref)]
} else = ret {
  # Find references in template strings, like:
  # * "...${LoggingBucket}..."
  # * "...${LoggingBucket.Arn}..."
  # * "...${AWS::Region}..."
  attr = {"Fn::Sub": template}
  is_string(template)
  ret := fn_sub_template_variables(template)
} else = ret {
  # Find references in template strings, like:
  attr = {"Fn::Sub": [template, variables]}
  is_string(template)
  template_vars := fn_sub_template_variables(template)
  ret := [value |
    variable := template_vars[_]
    value := object.get(variables, variable, variable)
  ]
}

# Extracting tags from a resource.
properties_tags(properties) = ret {
  is_array(properties.Tags)
  keys := {k | k := properties.Tags[_].Key}
  ret := {k: v |
    keys[k]
    vs := [tag.Value |
      tag := properties.Tags[_]
      tag.Key == k
      is_string(tag.Value)
    ]
    v := concat(";", vs)
  }
} else = ret {
  is_object(properties.Tags)
  ret := {k: v |
    v := properties.Tags[k]
    is_string(v)
  }
} else = ret {
  ret := {}
}
