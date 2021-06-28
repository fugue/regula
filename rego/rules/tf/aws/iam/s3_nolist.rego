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
package rules.tf_aws_iam_s3_nolist

import data.fugue
import data.aws.iam.policy_document_library as lib


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "Medium"
  },
  "description": "IAM policies should not allow broad list actions on S3 buckets. Should a malicious actor gain access to a role with a policy that includes broad list actions such as ListAllMyBuckets, the malicious actor would be able to enumerate all buckets and potentially extract sensitive data.",
  "id": "FG_R00218",
  "title": "IAM policies should not allow broad list actions on S3 buckets"
}

# All policy objects that have an ID and a `policy` field containing a JSON
# string.

policy_types = {
  "aws_iam_policy",
  "aws_iam_group_policy",
  "aws_iam_role_policy",
  "aws_iam_user_policy",
}

policies := {id: p |
  policy_types[ty]
  ps = fugue.resources(ty)
  p = ps[id]
}

# Bad policies.  Looking at all policies.
bad_policies := {id: p |
  p = policies[id]
  is_bad_policy(p)
}

# Looking for AWS-managed IAM policies in commercial AWS
aws_managed_policy(pol) {
  startswith(pol.arn, "arn:aws:iam::aws:policy/")
}

# Looking for AWS-managed IAM policies in AWS GovCloud regions
aws_govcloud_managed_policy(pol) {
  startswith(pol.arn, "arn:aws-us-gov:iam::aws:policy/")
}

# Looking for s3:ListAllMyBuckets in policy
# a policy having a statement that has all of:
#
#  "Action": "s3:ListAllMyBuckets"
#  "Effect": "Allow"

is_bad_policy(pol) {
  doc = lib.to_policy_document(pol.policy)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  actions = as_array(statement.Action)
  action = actions[_]
  bad_actions[action]

  resources = as_array(statement.Resource)
  is_bad_resource(resources[_])
}

bad_actions = {"s3:ListAllMyBuckets", "s3:*", "s3:List*"}

# Resources that are not allowed.
is_bad_resource(r) {
    r == "*"
} {
    re_match("^arn:aws[-0-9a-z]*:s3:::[*]$", r)
}

# Judge policies and bad policies. We exclude AWS-managed IAM policies from denied resources.
resource_type = "MULTIPLE"

policy[j] {
  pol = bad_policies[id]
  not aws_managed_policy(pol)
  not aws_govcloud_managed_policy(pol)
  j = fugue.deny_resource(pol)
} {
  pol = policies[id]
  not bad_policies[id]
  j = fugue.allow_resource(pol)
}

policy_attachment_types = {
  "aws_iam_role_policy_attachment",
  "aws_iam_user_policy_attachment",
}

# This would fit nicely in a library.
policy_attachments := ret {
  the_groups := {resource: attachments |
    groups = fugue.resources("aws_iam_group")
    group_attachments = fugue.resources("aws_iam_group_policy_attachment")
    resource = groups[resource_id]
    attachments = {attachment |
      attachment = group_attachments[_]
      resource.name = attachment.group
    }
  }
  the_roles := {resource: attachments |
    roles = fugue.resources("aws_iam_role")
    role_attachments = fugue.resources("aws_iam_role_policy_attachment")
    resource = roles[resource_id]
    attachments = {attachment |
      attachment = role_attachments[_]
      resource.name = attachment.role
    }
  }
  the_users := {resource: attachments |
    users = fugue.resources("aws_iam_user")
    user_attachments = fugue.resources("aws_iam_user_policy_attachment")
    resource = users[resource_id]
    attachments = {attachment |
      attachment = user_attachments[_]
      resource.name = attachment.user
    }
  }
  ret := object.union(the_groups, object.union(the_roles, the_users))
}

# The ARNs we want to avoid.
bad_managed_arn(arn) {
  re_match("^arn:aws[-0-9a-z]*:iam::aws:policy/AmazonS3FullAccess$", arn)
} {
  re_match("^arn:aws[-0-9a-z]*:iam::aws:policy/AmazonS3ReadOnlyAccess$", arn)
}

# In addition to judging policies, we also check that there are no policy
# attachments that have the AWS-managed AdministratorAccess policy.
#
# However, note that the resources that we return are not the attachments
# but rather the resources they are attached to.
policy[j] {
  attachments = policy_attachments[resource]
  count([a | a = attachments[_]; bad_managed_arn(a.policy_arn)]) > 0
  j = fugue.deny_resource(resource)
} {
  attachments = policy_attachments[resource]
  count([a | a = attachments[_]; bad_managed_arn(a.policy_arn)]) == 0
  j = fugue.allow_resource(resource)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}

