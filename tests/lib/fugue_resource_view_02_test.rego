# Copyright 2020 Fugue, Inc.
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
package fugue.resource_view

import data.tests.lib.inputs.resource_view_02_infra

test_resource_view_02 {
  resource_view_02_infra.mock_resources == {
    "aws_s3_bucket.example": {
      "id": "aws_s3_bucket.example",
      "acl": "private",
      "website": [],
      "replication_configuration": [],
      "cors_rule": [],
      "tags": null,
      "bucket_prefix": "example",
      "policy": null,
      "server_side_encryption_configuration": [],
      "grant": [],
      "object_lock_configuration": [],
      "logging": [],
      "lifecycle_rule": [],
      "_type": "aws_s3_bucket",
      "force_destroy": false
    },
    "data.aws_iam_policy_document.example": {
      "id": "data.aws_iam_policy_document.example",
      "statement": [{
        "actions": ["s3:*"],
        "sid": null,
        "not_resources": null,
        "resources": [
          "arn:aws:s3:::some-example-bucket/*",
          "aws_s3_bucket.example"
        ],
        "effect": "Allow",
        "condition": [],
        "not_principals": [],
        "principals": [{
          "type": "*",
          "identifiers": ["*"]
        }],
        "not_actions": null
      }],
      "override_json": null,
      "override_policy_documents": null,
      "source_policy_documents": null,
      "source_json": null,
      "version": null,
      "policy_id": null,
      "_type": "aws_iam_policy_document"
    },
    "aws_iam_policy.example": {
      "id": "aws_iam_policy.example",
      "description": null,
      "policy": "data.aws_iam_policy_document.example",
      "path": "/",
      "_type": "aws_iam_policy",
      "name_prefix": null
    }
  }
}
