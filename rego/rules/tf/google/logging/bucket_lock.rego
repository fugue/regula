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
package rules.tf_google_logging_bucket_lock

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_2.3"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_2.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "Logging storage bucket retention policies and Bucket Lock should be configured. A retention policy for a Cloud Storage bucket governs how long objects in the bucket must be retained. Bucket Lock is a feature to permanently restrict edits to the data retention policy. Bucket Lock should be enabled because it preserves activity logs for forensics and security investigations if the system is compromised by an attacker or malicious insider who wants to cover their tracks.",
  "id": "FG_R00393",
  "title": "Logging storage bucket retention policies and Bucket Lock should be configured"
}

resource_type = "MULTIPLE"

buckets = fugue.resources("google_storage_bucket")
sinks = fugue.resources("google_logging_project_sink")

sink_buckets[id] {
  bucket = buckets[id]
  sink = sinks[_]
  sink.destination == concat("/", ["storage.googleapis.com", bucket.name])
} {
  bucket = buckets[id]
  sink = sinks[_]
  sink.destination == bucket.name  # Work with names at design time
}

valid_retention_policy(bucket) {
  bucket.retention_policy[_].is_locked == true
}

policy[j] {
  bucket = buckets[id]
  sink_buckets[id]
  valid_retention_policy(bucket)
  j = fugue.allow_resource(bucket)
}

policy[j] {
  bucket = buckets[_]
  sink_buckets[id]
  not valid_retention_policy(bucket)
  j = fugue.deny_resource(bucket)
}

