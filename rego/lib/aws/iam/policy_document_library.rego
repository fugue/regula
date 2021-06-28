# Copyright 2020-2021 Fugue, Inc.
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
package aws.iam.policy_document_library

import data.fugue

make_principal(p) = ret {
  p.type == "*"
  ret = "*"
} else = ret {
  key = p.type
  ret = {key: p.identifiers}
}

make_condition(conditions) = ret {
  ret = {test: context_var_values |
    # Find all variables pertaining to this test.
    test := conditions[_].test
    context_vars := {condition.variable |
      condition := conditions[_]
      condition.test == test
    }

    # Now build an object with a list of values per variable.
    context_var_values := {var: values |
      var := context_vars[_]
      values := [value |
        condition := conditions[_]
        condition.test == test
        condition.variable == var
        value := condition.values[_]
      ]
    }
  }
}

make_statement(s) = ret {
  effect := object.get(s, "effect", "Allow")
  ret := {
    "Effect": effect,
    "Principal": [make_principal(p) | p = object.get(s, "principals", [])[_]],
    "Action": object.get(s, "actions", []),
    "Condition": make_condition(object.get(s, "condition", []))
  }
}

make_document(doc) = ret {
  ret := {
    "Statement": [make_statement(s) | s = object.get(doc, "statement", [])[_]],
  }
}

policy_documents := {global_id: ret |
  # This is a design-time only resource type so make sure it exists.
  fugue.resource_types_v0["aws_iam_policy_document"]
  doc := fugue.resources("aws_iam_policy_document")[global_id]
  ret := make_document(doc)
}

policy_document_ref_or_json_string(p) = true {
  _ = policy_documents[_]
} else = true {
  startswith(trim_space(p), "{")
  endswith(trim_space(p), "}")
} else = false {
  true
}

to_policy_document(pol) = ret {
  ret := policy_documents[pol]
} else = ret {
  is_array(pol)
  ret := policy_documents[pol[0]]
} else = ret {
  is_string(pol)
  startswith(trim_space(pol), "{")
  endswith(trim_space(pol), "}")
  ret := json.unmarshal(pol)
}

arn_or_id(resource) = ret {
  ret = resource.arn
} else = ret {
  ret = resource.id
}

