package rules.ec2_t2_only

resource_type = "aws_instance"

# Explicitly allow only blessed instance types.
# Disallowing only t2.nano would blindly allow new instance types.
valid_instance_types = {
  "t2.micro",
  "t2.small",
  "t2.medium",
  "t2.large",
  "t2.xlarge",
  "t2.2xlarge"
}

default allow = false

allow {
  valid_instance_types[input.instance_type]
}
