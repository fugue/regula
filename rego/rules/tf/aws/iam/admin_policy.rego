# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_iam_admin_policy

import data.fugue
import data.aws.iam.policy_document_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_1.16"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_1.16"
      ]
    },
    "severity": "High"
  },
  "description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
  "id": "FG_R00092",
  "title": "IAM policies should not have full \"*:*\" administrative privileges"
}

# All policy objects that have an ID and a `policy` field containing a JSON
# string.
policies[id] = p {
  ps = fugue.resources("aws_iam_policy"); p = ps[id]
} {
  ps = fugue.resources("aws_iam_group_policy"); p = ps[id]
} {
  ps = fugue.resources("aws_iam_role_policy"); p = ps[id]
} {
  ps = fugue.resources("aws_iam_user_policy"); p = ps[id]
}

# All wildcard policies.
wildcard_policies := {id: p |
  p = policies[id]
  is_wildcard_policy(p)
}

# Determine if a policy is a "wildcard policy".  A wildcard policy is defined as
# a policy having a statement that has all of:
#
# - Effect: Allow
# - Resource: "*"
# - Action: "*"
is_wildcard_policy(pol) {
  doc = lib.to_policy_document(pol.policy)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  resources = as_array(statement.Resource)
  resource = resources[_]
  resource == "*"

  actions = as_array(statement.Action)
  action = actions[_]
  action == "*"
}

# Looking for AWS-managed IAM policies in AWS commercial regions
aws_managed_policy(pol) {
   policy_arn = pol.arn
   prefix = "arn:aws:iam::aws:policy/"
   startswith(policy_arn, prefix)
 }

# Looking for AWS-managed IAM policies in AWS GovCloud regions
aws_govcloud_managed_policy(pol) {
   policy_arn = pol.arn
   prefix = "arn:aws-us-gov:iam::aws:policy/"
   startswith(policy_arn, prefix)
 }

# Judge policies and wildcard policies.
resource_type := "MULTIPLE"

policy[j] {
  pol = wildcard_policies[id]
  not aws_managed_policy(pol)
  not aws_govcloud_managed_policy(pol)
  j = fugue.deny_resource(pol)
} {
  pol = policies[id]
  not wildcard_policies[id]
  j = fugue.allow_resource(pol)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}
