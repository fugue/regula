package rules.iam_password_length

import data.fugue

# We need to write an advanced rule so we can take care of the case when there's
# no policy at all.
resource_type = "MULTIPLE"

# All password policies in the input.
password_policies = fugue.resources("aws_iam_account_password_policy")

# Is there at least one password policy in the input?
exists_password_policy {
  _ = password_policies[_]
}

# Is the password policy in compliance?
valid_password_policy(pol) {
  # If you want to make any changes to these check, this helper function is
  # the only thing that needs to be edited.  `aws_iam_account_password_policy`
  # has a large number of useful fields!
  pol.minimum_password_length >= 8
}

# Hook up the policy using the two auxiliary rules above.
policy[p] {
  not exists_password_policy
  p = fugue.missing_resource_with_message(
    "aws_iam_account_password_policy",
    "No aws_iam_account_password_policy present")
} {
  pol = password_policies[_]
  valid_password_policy(pol)
  p = fugue.allow_resource(pol)
} {
  pol = password_policies[_]
  not valid_password_policy(pol)
  p = fugue.deny_resource_with_message(pol,
    "minimum_password_length must be set to at least 8")
}
