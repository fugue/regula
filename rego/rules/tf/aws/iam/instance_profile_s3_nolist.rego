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
package rules.tf_aws_iam_instance_profile_s3_nolist

import data.fugue
import data.aws.iam.policy_document_library as lib


__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "IAM roles attached to instance profiles should not allow broad list actions on S3 buckets. Instance profiles contain trust policies that enable EC2 instances to assume IAM roles. To prevent compromised EC2 instances from being able to effectively survey all S3 buckets and potentionally access sensitive data, trust policies attached to instance profiles should not allow list actions on S3 buckets.",
  "id": "FG_R00220",
  "title": "IAM roles attached to instance profiles should not allow broad list actions on S3 buckets"
}

# Grabbing all resources
roles = fugue.resources("aws_iam_role")
instance_profiles = fugue.resources("aws_iam_instance_profile")
role_policies = fugue.resources("aws_iam_role_policy")
iam_policies = fugue.resources("aws_iam_policy")
role_policy_attachments = fugue.resources("aws_iam_role_policy_attachment")

# A set of roles used in instance profiles.
relevant_role_names := {role_name |
  role_name = instance_profiles[_].role
}

# Only roles that are associated with instance profiles are relevant.
relevant_roles := {id: role |
  role = roles[id]
  relevant_role_names[role.name]
}

# Actions that are not allowed.
bad_actions = {"s3:ListAllMyBuckets", "s3:*", "s3:List*"}

# Resources that are not allowed.
is_bad_resource(r) {
    r == "*"
} {
    re_match("^arn:aws[-0-9a-z]*:s3:::[*]$", r)
}

# Determine if a policy enables list actions on S3. This occurs in a trust policy that has all of:
# - Effect: "Allow"
# - Action: "s3:ListAllMyBuckets", "s3:*", "s3:List*"
is_bad_policy(pol) {
  doc = lib.to_policy_document(pol)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  actions = as_array(statement.Action)
  bad_actions[actions[_]]

  resources = as_array(statement.Resource)
  is_bad_resource(resources[_])
}

# Create a set of bad role names.  Use comprehensions to force OPA to fully
# evaluate it.
bad_role_names := ret {
  ret = {pol.role |
    pol = role_policies[_]
    relevant_role_names[pol.role]
    is_bad_policy(pol.policy)
  } | {attachment.role |
    attachment = role_policy_attachments[_]
    relevant_role_names[attachment.role]
    is_bad_policy_arn(attachment.policy_arn)
  }
}

# Create a set of bad policy ARNs.
is_bad_policy_arn(arn) {
  re_match("^arn:aws[-0-9a-z]*:iam::aws:policy/AmazonS3FullAccess$", arn)
} {
  re_match("^arn:aws[-0-9a-z]*:iam::aws:policy/AmazonS3ReadOnlyAccess$", arn)
} {
  pol = iam_policies[_]
  arn = lib.arn_or_id(pol)
  not re_match(arn, "^arn:aws[-0-9a-z]*:iam::aws:")  # Not AWS-managed.
  is_bad_policy(pol.policy)
}

# Judge roles
resource_type := "MULTIPLE"

policy[j] {
  role = relevant_roles[_]
  bad_role_names[role.name]
  j = fugue.deny_resource(role)
} {
  role = relevant_roles[_]
  not bad_role_names[role.name]
  j = fugue.allow_resource(role)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}
