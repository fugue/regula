# Copyright 2021 Fugue, Inc.
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

package rules.arm_storage_account_queue_logging

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00440",
	"title": "Storage Queue logging should be enabled for read, write, and delete requests",
	"description": "Storage account read, write, and delete logging for Storage Queues is not enabled by default. Logging should be enabled so that users can monitor queues for security and performance issues.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_3.3"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "Microsoft.Storage/storageAccounts/queueServices/providers/diagnosticsettings"

default allow = false

allow {
	enabled_log_categories := {lower(log.category) |
		log := input.properties.logs[_]
		log.enabled == true
	}

	enabled_log_categories["storageread"]
	enabled_log_categories["storagewrite"]
	enabled_log_categories["storagedelete"]
}
