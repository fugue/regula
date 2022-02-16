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
package rules.tf_aws_redshift_cluster_public

__rego__metadoc__ := {
  "custom": {
    "severity": "Critical"
  },
  "description": "Redshift cluster 'Publicly Accessible' should not be enabled. Publicly accessible Redshift clusters allow any AWS user or anonymous user access to the data in the database. Redshift clusters should not be publicly accessible.",
  "id": "FG_R00270",
  "title": "Redshift cluster 'Publicly Accessible' should not be enabled"
}

resource_type := "aws_redshift_cluster"

default allow = false

allow {
  input.publicly_accessible == false
}
