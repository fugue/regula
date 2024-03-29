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
package rules.tf_aws_s3_replication

import data.fugue
import data.aws.s3.s3_library as lib

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "S3 bucket replication (cross-region or same-region) should be enabled. Cross-Region S3 replication can help with meeting compliance requirements, minimizing latency, and increasing operational efficiency. Same-Region S3 replication can help with aggregating logs and compliance with data sovereignty laws.",
  "id": "FG_R00275",
  "title": "S3 bucket replication (cross-region or same-region) should be enabled"
}

resource_type := "MULTIPLE"

buckets = fugue.resources("aws_s3_bucket")

bucket_replication_by_bucket := ret {
  fugue.input_resource_types["aws_s3_bucket_replication_configuration"]
  confs := fugue.resources("aws_s3_bucket_replication_configuration")
  ret := {conf.bucket: conf | conf := confs[_]}
}

bucket_has_replication(bucket) {
  _ = bucket.replication_configuration[_]
}

bucket_has_replication(bucket) {
  _ = bucket_replication_by_bucket[lib.bucket_name_or_id(bucket)]
}

policy[p] {
  bucket := buckets[_]
  bucket_has_replication(bucket)
  p := fugue.allow_resource(bucket)
} {
  bucket := buckets[_]
  not bucket_has_replication(bucket)
  p := fugue.deny_resource(bucket)
}
