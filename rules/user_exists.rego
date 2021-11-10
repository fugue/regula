package rules.dockerfile_user_exists

import data.fugue

__rego__metadoc__ := {
	"custom": {
		"controls": {},
		"severity": "Medium",
	},
	"description": "Description",
	"id": "FG_R00999",
	"title": "Title",
}

input_type = "dockerfile"

resource_type = "MULTIPLE"

is_invalid(file) {
	file.commands[_].type == "ADD"
}

policy[j] {
	resource := input.resources[_]
	is_invalid(resource)
	j = fugue.deny_resource_with_message(resource, "Has ADD command!")
}

policy[j] {
	resource := input.resources[_]
	not is_invalid(resource)
	j = fugue.allow_resource(resource)
}
