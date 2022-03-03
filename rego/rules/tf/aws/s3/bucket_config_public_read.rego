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
package rules.tf_aws_s3_bucket_config_public_read

import data.fugue
import data.aws.s3.s3_library as lib
import data.aws.s3.s3_public_library as public
import data.aws.iam.policy_document_library as doclib

# S3 buckets should not be configured for public access
#
# aws_s3_bucket
# aws_s3_bucket_policy

__rego__metadoc__ := {
  "custom": {
    "severity": "High"
  },
  "description": "S3 bucket policies and ACLs should not be configured for public read access. It is a security risk for a bucket to have an ACL or bucket policy that is configured for public read access, even if the bucket itself is not currently public. A bucket configured for public read access can potentially be made public, allowing any AWS user or anonymous user to access the data in it.",
  "id": "FG_R00279",
  "title": "S3 bucket policies and ACLs should not be configured for public read access"
}

resource_type := "MULTIPLE"

base_message = "S3 buckets should not be configured for public access:"

buckets = fugue.resources("aws_s3_bucket")

# https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#canned-acl
# Invalid canned ACL is "public-read", "public-read-write",
invalid_canned_acl = {"public-read", "public-read-write"}

# https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#specifying-grantee-predefined-groups
# Grantee groups take the form of URIs:
#  - http://acs.amazonaws.com/groups/global/AuthenticatedUsers
#  - http://acs.amazonaws.com/groups/global/AllUsers
invalid_grant_uris = {
  "http://acs.amazonaws.com/groups/global/AuthenticatedUsers",
  "http://acs.amazonaws.com/groups/global/AllUsers"
}

invalid_permissions = {"READ", "FULL_CONTROL", "READ_ACP"}

invalid_grant(grants) {
  grant = grants[_]
  perms = grant.permissions[_]
  invalid_permissions[perms]
  invalid_grant_uris[grant.uri]
}

# https://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html#permissions
invalid_actions = {
  "*",
  "s3:*",
  "s3:List*",
  "s3:Get*",
  "s3:ListBucket*",
  "s3:GetObject*",
  "s3:ListBucket",
  "s3:ListBucketVersions",
  "s3:ListBucketMultipartUploads",
  "s3:GetObject",
  "s3:GetObjectVersion",
  "s3:GetObjectTorrent"
}

invalid_bucket_policy(pol) {
  doc = doclib.to_policy_document(pol)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  actions = as_array(statement.Action)
  action = actions[_]
  invalid_actions[action]

  principals = as_array(statement.Principal)
  principal = principals[_]
  public.invalid_principal(principal)
}

bucket_invalid_reason(b) = concat(" ", [base_message, "An ACL allows public access to the bucket"]) {
  invalid_canned_acl[b.acl]
} else = concat(" ", [base_message, "A grant allows public access to the bucket"]) {
  invalid_grant(b.grant)
} else = concat(" ", [base_message, "A bucket policy allows public access to the bucket"]) {
  policies = lib.bucket_policies_for_bucket(b)
  pol = policies[_]
  invalid_bucket_policy(pol)
}

policy[j] {
  b = buckets[_]
  not bucket_invalid_reason(b)
  j = fugue.allow_resource(b)
 } {
  b = buckets[_]
  bucket_name = lib.bucket_name_or_id(b)
  reason = bucket_invalid_reason(b)
  j = fugue.deny_resource_with_message(b, reason)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}
