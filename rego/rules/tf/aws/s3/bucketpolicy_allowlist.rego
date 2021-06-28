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
package rules.aws_s3_bucketpolicy_allowlist

import data.fugue
import data.aws.s3.s3_library as lib
import data.aws.s3.s3_public_library as public
import data.aws.iam.policy_document_library as doclib

# S3 bucket policies should not allow list actions for all principals. S3 bucket policies list actions enable users to enumerate information on an organization's S3 buckets and objects. Malicious actors may use this information to identify potential targets for hacks. Users should scope list actions only to users and roles that require this information - not all principals.
# 
# aws_s3_bucket
# aws_s3_bucket_policy


__rego__metadoc__ := {
  "custom": {
    "controls": {},
    "severity": "High"
  },
  "description": "S3 bucket policies should not allow list actions for all IAM principals and public users. S3 bucket policies list actions enable users to enumerate information on an organization's S3 buckets and objects. Malicious actors may use this information to identify potential targets for hacks. Users should scope list actions only to users and roles that require this information - not all principals.",
  "id": "FG_R00211",
  "title": "S3 bucket policies should not allow list actions for all IAM principals and public users"
}

resource_type = "MULTIPLE"

buckets = lib.buckets_with_valid_policies

invalid_buckets[bucket_id] = bucket {
  bucket = buckets[bucket_id]
  policies = lib.bucket_policies_for_bucket(bucket)
  pol = policies[_]
  list_all(pol)
}

# Determine if a bucket policy allows list actions for all principals as follows:
# - Effect: Allow
# - Action: "list"
# - Principal: "*"
list_all(pol) {
  doc = doclib.to_policy_document(pol)
  statements = as_array(doc.Statement)
  statement = statements[_]

  statement.Effect == "Allow"

  actions = as_array(statement.Action)
  related_actions = {"s3:List*", "s3:ListJobs", "s3:ListBucket", "s3:ListBucketVersions", "s3:ListMultipartUploadParts"}
  related_actions[actions[_]]

  principals = as_array(statement.Principal)
  principal = principals[_]
  public.invalid_principal(principal)
}

policy[j] {
  b = invalid_buckets[_]
  j = fugue.deny_resource(b)
} {
  b = buckets[id]
  not invalid_buckets[id]
  j = fugue.allow_resource(b)
}

# Utility: turns anything into an array, if it's not an array already.
as_array(x) = [x] {not is_array(x)} else = x {true}

