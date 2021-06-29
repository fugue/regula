# Writing Tests

Consult [OPA's documentation](https://www.openpolicyagent.org/docs/latest/policy-testing/) for general information on writing test rules, whose names must begin with `test_` (e.g., `test_my_rule`).

Test inputs start with an IaC file. Regula dynamically generates various kinds of test inputs from a single IaC file.

The test input used for simple and advanced rules is different:

- [Simple rules](writing-rules.md#simple-rules) use `mock_resources` test input.
- [Advanced rules](writing-rules.md#advanced-rules) use `mock_input` test input.

For a deep dive into test input, see [Test Inputs](test-inputs.md).

### Writing a test for a simple rule

Suppose you're writing a **simple rule** that checks whether AWS EBS volumes are encrypted:

```ruby
package rules.tf_aws_ebs_volume_encrypted

resource_type = "aws_ebs_volume"

default allow = false

allow {
  input.encrypted == true
}
```

Here's the **test IaC** you might use as test input, containing a valid (encrypted) and invalid (unencrypted) EBS volume, and the [**`mock_resources`**](test-inputs.md) Regula generates from it:

=== "volume_encrypted_infra.tf"

    ```tf
    provider "aws" {
      region = "us-east-2"
    }

    resource "aws_ebs_volume" "good" {
      availability_zone = "us-west-2a"
      size              = 40
      encrypted         = true
    }

    resource "aws_ebs_volume" "bad" {
      availability_zone = "us-west-2a"
      size              = 40
      encrypted         = false
    }
    ```

=== "mock_resources"

    ```json
    {
      "aws_ebs_volume.bad": {
        "_provider": "aws",
        "_type": "aws_ebs_volume",
        "availability_zone": "us-west-2a",
        "encrypted": false,
        "id": "aws_ebs_volume.bad",
        "size": 40
      },
      "aws_ebs_volume.good": {
        "_provider": "aws",
        "_type": "aws_ebs_volume",
        "availability_zone": "us-west-2a",
        "encrypted": true,
        "id": "aws_ebs_volume.good",
        "size": 40
      }
    }
    ```

Finally, here is the **test file** for the simple rule. It contains two tests, a valid and invalid case. Note that because this is a simple rule, `mock_resources` is imported as [test input](test-inputs.md) (see [this note](test-inputs.md#a-note-about-test-input-package-names) about the package name):

```ruby hl_lines="3"
package rules.tf_aws_ebs_volume_encrypted_simple

import data.volume_encrypted_infra_tf.mock_resources

test_valid_ebs_volume_encrypted {
  allow with input as mock_resources["aws_ebs_volume.good"]
}

test_invalid_ebs_volume_encrypted {
  not allow with input as mock_resources["aws_ebs_volume.bad"]
}
```

### Writing a test for an advanced rule

Suppose you've written an **advanced rule** that checks whether AWS EBS volumes are encrypted. For this example, we've just converted the simple rule above to an advanced rule:

```ruby
package rules.tf_aws_ebs_volume_encrypted_advanced

import data.fugue

resource_type = "MULTIPLE"

volumes = fugue.resources("aws_ebs_volume")

policy[p] {
  volume = volumes[_]
  volume.encrypted == true
  p = fugue.allow_resource(volume)
} {
  volume = volumes[_]
  volume.encrypted == false
  p = fugue.deny_resource(volume)
}
```

You can use the **same test IaC** for test input, but this time, you'd use the [**`mock_input`**](test-inputs.md):

=== "volume_encrypted_infra.tf"

    ```tf
    provider "aws" {
      region = "us-east-2"
    }

    resource "aws_ebs_volume" "good" {
      availability_zone = "us-west-2a"
      size              = 40
      encrypted         = true
    }

    resource "aws_ebs_volume" "bad" {
      availability_zone = "us-west-2a"
      size              = 40
      encrypted         = false
    }
    ```

=== "mock_input"

    ```json
    {
      "resources": {
        "aws_ebs_volume.bad": {
          "_provider": "aws",
          "_type": "aws_ebs_volume",
          "availability_zone": "us-west-2a",
          "encrypted": false,
          "id": "aws_ebs_volume.bad",
          "size": 40
        },
        "aws_ebs_volume.good": {
          "_provider": "aws",
          "_type": "aws_ebs_volume",
          "availability_zone": "us-west-2a",
          "encrypted": true,
          "id": "aws_ebs_volume.good",
          "size": 40
        }
      }
    }
    ```

Finally, here is the **test file** for the advanced rule. It contains one test that checks a valid and invalid case. Because we're testing an advanced rule, `mock_input` is imported as [test input](test-inputs.md) (see [this note](test-inputs.md#a-note-about-test-input-package-names) about the package name):

```ruby hl_lines="3"
package rules.tf_aws_ebs_volume_encrypted_advanced

import data.volume_encrypted_infra_tf.mock_input

test_ebs_volume_encrypted {
  pol := policy with input as mock_input
  resources := {p.id: p.valid | p := pol[_]}
  resources["aws_ebs_volume.good"] == true
  resources["aws_ebs_volume.bad"] == false
}
```

!!! tip
    To learn more about the types of test inputs and how to view them, see [Test Inputs](test-inputs.md).

## Example rules and tests

You can view the [Regula library of rules](https://github.com/fugue/regula/tree/master/rego/rules) and accompanying [tests](https://github.com/fugue/regula/tree/master/rego/tests/rules) for reference. You'll also find some [example rules](https://github.com/fugue/regula/tree/master/rego/examples/aws) and [their tests](https://github.com/fugue/regula/tree/master/rego/tests/examples/aws) in the repo.