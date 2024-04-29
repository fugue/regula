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
package rules.tf_aws_s3_versioning_lifecycle_enabled

import data.aws.s3.s3_library as lib
import data.fugue

__rego__metadoc__ := {
	"custom": {"severity": "Medium"},
	"description": "S3 bucket versioning and lifecycle policies should be enabled. S3 bucket versioning and lifecycle policies are used to protect data availability and integrity. By enabling object versioning, data is protected from overwrites and deletions. Lifecycle policies ensure sensitive data is deleted when appropriate.",
	"id": "FG_R00101",
	"title": "S3 bucket versioning and lifecycle policies should be enabled",
}

resource_type := "MULTIPLE"

buckets := fugue.resources("aws_s3_bucket")

bucket_lifecycle_configuration := fugue.resources("aws_s3_bucket_lifecycle_configuration")

bucket_versioning := fugue.resources("aws_s3_bucket_versioning")

bucket_versioning_enabled(bucket) {
	bucket.versioning[_].enabled
}

bucket_versioning_enabled(bucket) {
	conf := bucket_versioning_configs[lib.bucket_name_or_id(bucket)]
	lower(conf.versioning_configuration[_].status) == "enabled"
}

bucket_versioning_enabled(bucket) {
	bucket_versioning_conf := bucket_versioning[_]
	bucket_versioning_conf.bucket == bucket.id
	lower(bucket_versioning_conf.versioning_configuration[_].status) == "enabled"
}

bucket_has_lifecycle_policy(bucket) {
	count(bucket.lifecycle_rule) >= 1
}

bucket_has_lifecycle_policy(bucket) {
	conf := bucket_lifecycle_configs[lib.bucket_name_or_id(bucket)]
	count(conf.rule) >= 1
}

bucket_has_lifecycle_policy(bucket) {
	bucket_lifecycle_conf := bucket_lifecycle_configuration[_]
	bucket_lifecycle_conf.bucket == bucket.id
	conf := count(bucket_lifecycle_conf.rule) >= 1
}

bucket_versioning_enabled(bucket) {
	bucket_lifecycle_conf := bucket_lifecycle_configuration[_]
	bucket_lifecycle_conf.bucket == bucket.id
	count(bucket_lifecycle_conf.rule) >= 1
}

bucket_versioning_configs := ret {
	fugue.input_resource_types.aws_s3_bucket_versioning
	confs := fugue.resources("aws_s3_bucket_versioning")
	ret := {conf.bucket: conf | conf := confs[_]}
}

bucket_lifecycle_configs := ret {
	fugue.input_resource_types.aws_s3_bucket_lifecycle_configuration
	confs := fugue.resources("aws_s3_bucket_lifecycle_configuration")
	ret := {conf.bucket: conf | conf := confs[_]}
}

bucket_valid(bucket) {
	bucket_versioning_enabled(bucket)
	bucket_has_lifecycle_policy(bucket)
}

policy[p] {
	bucket := buckets[_]
	bucket_valid(bucket)
	p := fugue.allow_resource(bucket)
}

policy[p] {
	bucket := buckets[_]
	not bucket_valid(bucket)
	p := fugue.deny_resource(bucket)
}
