package rules.user_attached_policy

import data.fugue

resource_type = "MULTIPLE"

controls = {"CIS_1-16", "REGULA_R00001"}

# IAM policies should not be attached to users. Assigning privileges at the group or role level reduces the complexity of access management as the number of users grow. Reducing access management complexity may reduce opportunity for a principal to inadvertently receive or retain excessive privileges.

user_policies = fugue.resources("aws_iam_user_policy")
user_policy_attachments = fugue.resources("aws_iam_user_policy_attachment")
policy_attachments = fugue.resources("aws_iam_policy_attachment")

all_policy_resources[name] = p {
  p = user_policies[name]
} {
  p = user_policy_attachments[name]
} {
  p = policy_attachments[name]
}

is_invalid(resource) {
  resource = user_policies[name]
} {
  resource = user_policy_attachments[name]
} {
  resource = policy_attachments[name]
  resource.users != null
  resource.users != [""]
}

policy[p] {
  resource = all_policy_resources[name]
  is_invalid(resource)
  p = fugue.deny_resource(resource)
} {
  resource = all_policy_resources[name]
  not is_invalid(resource)
  p = fugue.allow_resource(resource)
}
