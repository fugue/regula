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

import data.tests.lib.inputs.resource_view_02

test_resource_view_02 {
  resource_view_02.mock_resources == {
    "aws_iam_policy.example": {
      "_type": "aws_iam_policy",
      "description": null,
      "id": "aws_iam_policy.example",
      "name_prefix": null,
      "path": "/",
      "policy": "data.aws_iam_policy_document.example"
    },
    "aws_s3_bucket.example": {
      "_type": "aws_s3_bucket",
      "acl": "private",
      "bucket_prefix": "example",
      "cors_rule": [],
      "force_destroy": false,
      "grant": [],
      "id": "aws_s3_bucket.example",
      "lifecycle_rule": [],
      "logging": [],
      "object_lock_configuration": [],
      "policy": null,
      "replication_configuration": [],
      "server_side_encryption_configuration": [],
      "tags": null,
      "website": []
    },
    "data.aws_iam_policy_document.example": {
      "_type": "aws_iam_policy_document",
      "id": "data.aws_iam_policy_document.example",
      "override_json": null,
      "policy_id": null,
      "source_json": null,
      "statement": [
        {
          "actions": [
            "s3:*"
          ],
          "condition": [],
          "effect": "Allow",
          "not_actions": null,
          "not_principals": [],
          "not_resources": null,
          "principals": [
            {
              "identifiers": [
                "*"
              ],
              "type": "*"
            }
          ],
          "resources": [
              "arn:aws:s3:::some-example-bucket/*",
              "aws_s3_bucket.example"
          ],
          "sid": null
        }
      ],
      "version": null
    }
  }
}
