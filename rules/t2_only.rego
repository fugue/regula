package rules.t2_only

import data.fugue

resource_type = "MULTIPLE"

instances = fugue.resources("aws_instance")

# Explicitly allow only blessed instance types.
# Disallowing only t2.nano would blindly allow new instance types.
valid_instance(instance) {
    instance.instance_type == "t2.micro"
} {
    instance.instance_type == "t2.small"
} {
    instance.instance_type == "t2.medium"
} {
    instance.instance_type == "t2.large"
} {
    instance.instance_type == "t2.xlarge"
} {
    instance.instance_type == "t2.2xlarge"
}

policy[p] {
    instance = instances[_]
    valid_instance(instance)
    p = fugue.allow_resource(instance)
} {
    instance = instances[_]
    not valid_instance(instance)
    p = fugue.deny_resource(instance)
}
