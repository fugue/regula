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
package aws.s3.s3_library

import data.fugue

# Retrieves all bucket policies for a bucket, returned as a list.
# Bucket policies can be defined as part of the bucket or as
# a separate resource.
bucket_policies_for_bucket(bucket) = ret {
  bucket_policies = fugue.resources("aws_s3_bucket_policy")

  ret = array.concat(
    # Inlined
    [pol | pol = bucket.policy; bucket.policy != null],
    # External
    [pol.policy |
      pol = bucket_policies[_]
      matches_bucket_or_id(pol.bucket, bucket)
    ]
  )
}

bucket_acls_by_bucket := ret {
  fugue.input_resource_types["aws_s3_bucket_acl"]
  acls := fugue.resources("aws_s3_bucket_acl")
  ret := {acl.bucket: acl | acl := acls[_]}
}

bucket_logging_by_bucket := ret {
  fugue.input_resource_types["aws_s3_bucket_logging"]
  confs := fugue.resources("aws_s3_bucket_logging")
  ret := {conf.bucket: conf | conf := confs[_]}
}

matches_bucket_or_id(val, bucket) {
  not is_null(val)
  val == bucket.bucket
}

matches_bucket_or_id(val, bucket) {
  not is_null(val)
  val == bucket.id
}

bucket_name_or_id(bucket) = ret {
  ret = bucket.bucket
} else = ret {
  ret = bucket.id
}
