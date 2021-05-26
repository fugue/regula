# Rule Development

Custom rule development generally has three parts:

- Writing the IaC to be used as [test input](#test-inputs)
- Writing the rule (as documented in [Writing Rules](writing-rules.md))
- Writing the [rule tests](#writing-tests)

Understanding how Regula handles inputs is key to developing your own rules, since the test input can be used to help you write the rule and the rule tests.

## Test inputs

When Regula reads in an IaC file, it transforms the IaC into three types of JSON-formatted inputs:

- `mock_config` -- the raw JSON representation fed into OPA.
- `mock_input` -- a transformed representation of the `mock_config` that is used as input for [advanced rules](writing-rules.md#advanced-rules). This is known as the **resource view**.
- `mock_resources` -- an alias for `mock_input.resources`, which is used as input for [simple rules](writing-rules.md#simple-rules).

Regula dynamically generates each type of input at runtime when the IaC file is loaded, so you don't need to run a script to generate it. You can simply:

- Load the files into [`regula repl`](../usage.md#repl) to [view the test input](#viewing-test-inputs) and help you [write a rule](writing-rules.md) or [write a test](#writing-tests)
- Load the files into [`regula repl`](../usage.md#repl) to [interactively evaluate tests](#test-a-rule-via-regula-repl)
- Load the files into [`regula test`](../usage.md#test) to [run the tests](#test-a-rule-via-regula-test)

### A note about test input

The package name for the test input is based on its path, relative to where you'll be running [`regula repl`](../usage.md#repl) or [`regula test`](../usage.md#test).

- When you invoke the command, make sure you're running it from the correct directory relative to the package name.
- When you write the test, make sure you're referring to the package name relative to where you'll be running the command.

The package name will follow this pattern:

```
<path.to.file>.<iac filename without extension>_<extension>
```

For instance, the package name for the file located at `infra/cfn_resources.yaml` would look like this:

```
infra.cfn_resources_yaml
```

When used to view test inputs in `regula repl`, prepend with `data` and add the input type:

```
data.infra.cfn_resources_yaml.mock_config
data.infra.cfn_resources_yaml.mock_input
data.infra.cfn_resources_yaml.mock_resources
```

You can import the package into a test file like so:

```
import data.infra.cfn_resources_yaml
```

When referenced in a `test_` for a simple rule, refer to the `mock_resources`:

```
test_valid_my_simple_rule {
  my_rule.allow with input as cfn_resources_yaml.mock_resources["ValidResourceIDHere"]
}
```

When referenced in a `test_` for an advanced rule, refer to the `mock_input`:

```
test_my_advanced_rule {
  pol = policy with input as cfn_resources_yaml.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["ValidResourceIDHere"] == true
}
```

### Viewing test inputs

You can easily view each type of test input for an IaC file by following the steps below:

1. Load the IaC file or directory of files into [`regula repl`](../usage.md#repl). Example:

        regula repl infra

2. Enter the package name of the input type you want to view, following this pattern (as explained [above](#a-note-about-test-input)):

        data.<path.to.file>.<iac filename without extension>_<extension>.<input type>
        
    Examples:

        data.infra.cfn_resources_yaml.mock_config
        data.infra.cfn_resources_yaml.mock_input
        data.infra.cfn_resources_yaml.mock_resources

Here's how all three input types look for an example CloudFormation file:

=== "cfn_resources.yaml"

    ```
    AWSTemplateFormatVersion: '2010-09-09'
    Resources:
      ValidManagedPolicy01:
        Type: AWS::IAM::ManagedPolicy
        Properties:
          Description: 'This is a super long description hooray'
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Deny
              Action: '*'
              Resource: '*'

      InvalidManagedPolicy01:
        Type: AWS::IAM::ManagedPolicy
        Properties:
          Description: 'too short'
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Deny
              Action: '*'
              Resource: '*'
    ```

=== "mock_config"

    ```
    {
      "AWSTemplateFormatVersion": "2010-09-09",
      "Resources": {
        "InvalidManagedPolicy01": {
          "Properties": {
            "Description": "too short",
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "*",
                  "Effect": "Deny",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            }
          },
          "Type": "AWS::IAM::ManagedPolicy"
        },
        "ValidManagedPolicy01": {
          "Properties": {
            "Description": "This is a super long description hooray",
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "*",
                  "Effect": "Deny",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            }
          },
          "Type": "AWS::IAM::ManagedPolicy"
        }
      }
    }
    ```

=== "mock_input"

    ```
    {
      "_template": {
        "AWSTemplateFormatVersion": "2010-09-09",
        "Resources": {
          "InvalidManagedPolicy01": {
            "Properties": {
              "Description": "too short",
              "PolicyDocument": {
                "Statement": [
                  {
                    "Action": "*",
                    "Effect": "Deny",
                    "Resource": "*"
                  }
                ],
                "Version": "2012-10-17"
              }
            },
            "Type": "AWS::IAM::ManagedPolicy"
          },
          "ValidManagedPolicy01": {
            "Properties": {
              "Description": "This is a super long description hooray",
              "PolicyDocument": {
                "Statement": [
                  {
                    "Action": "*",
                    "Effect": "Deny",
                    "Resource": "*"
                  }
                ],
                "Version": "2012-10-17"
              }
            },
            "Type": "AWS::IAM::ManagedPolicy"
          }
        }
      },
      "resources": {
        "InvalidManagedPolicy01": {
          "Description": "too short",
          "PolicyDocument": {
            "Statement": [
              {
                "Action": "*",
                "Effect": "Deny",
                "Resource": "*"
              }
            ],
            "Version": "2012-10-17"
          },
          "_provider": "aws",
          "_type": "AWS::IAM::ManagedPolicy",
          "id": "InvalidManagedPolicy01"
        },
        "ValidManagedPolicy01": {
          "Description": "This is a super long description hooray",
          "PolicyDocument": {
            "Statement": [
              {
                "Action": "*",
                "Effect": "Deny",
                "Resource": "*"
              }
            ],
            "Version": "2012-10-17"
          },
          "_provider": "aws",
          "_type": "AWS::IAM::ManagedPolicy",
          "id": "ValidManagedPolicy01"
        }
      }
    }
    ```

=== "mock_resources"

    ```
    {
      "InvalidManagedPolicy01": {
        "Description": "too short",
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "*",
              "Effect": "Deny",
              "Resource": "*"
            }
          ],
          "Version": "2012-10-17"
        },
        "_provider": "aws",
        "_type": "AWS::IAM::ManagedPolicy",
        "id": "InvalidManagedPolicy01"
      },
      "ValidManagedPolicy01": {
        "Description": "This is a super long description hooray",
        "PolicyDocument": {
          "Statement": [
            {
              "Action": "*",
              "Effect": "Deny",
              "Resource": "*"
            }
          ],
          "Version": "2012-10-17"
        },
        "_provider": "aws",
        "_type": "AWS::IAM::ManagedPolicy",
        "id": "ValidManagedPolicy01"
      }
    }
    ```

## Writing tests

Consult [OPA's documentation](https://www.openpolicyagent.org/docs/latest/policy-testing/) for information on writing test rules, whose names must begin with `test_` (e.g., `test_my_rule`).

In the Rego file containing the tests, you'll need to import the test input. Follow the pattern below to specify the package (as explained in [this note](#a-note-about-test-input)):

```
import data.<path.to.file>.<iac filename without extension>_<extension>
```

For instance:

```
import data.infra.cfn_resources_yaml
```

The path to the file should be relative to where you'll be running [`regula repl`](../usage.md#repl) or [`regula test`](../usage.md#test).

In the `test_` rule, set the input to `mock_resources` for [simple rules](writing-rules.md#simple-rules) and `mock_input` for [advanced rules](writing-rules.md#advanced-rules).

For instance, suppose you're writing a simple rule, and your IaC file is located at `infra/cfn_resources.yaml`. You'd import `data.infra.cfn_resources_yaml`, which you can then reference in a `test_` with `cfn_resources_yaml.mock_resources`. 

The contents of the Rego test file `my_test.rego` might look like this:

```
package tests.my_test

import data.rules.my_rule
import data.infra.cfn_resources_yaml

test_valid_my_rule {
  my_rule.allow with input as cfn_resources_yaml.mock_resources["ValidResourceIDHere"]
}

test_invalid_my_rule {
  not my_rule.allow with input as cfn_resources_yaml.mock_resources["InvalidResourceIDHere"]
}
```

Likewise, suppose you're writing an advanced rule, and your IaC file is located at `infra/my_resources.tf`. You'd import `data.infra.my_resources_tf`, which you can then reference in a `test_` with `my_resources_tf.mock_input`. 

The contents of the Rego test file `my_advanced_test.rego` might look like this:

```
package tests.my_advanced_test

import data.rules.my_advanced_rule
import data.infra.my_resources_tf

test_my_rule {
  pol = policy with input as my_resources_tf.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["ValidResourceIDHere"] == true
  by_resource_id["InvalidResourceIDHere"] == false
}
```

## Testing rules

You can run rule tests using [`regula test`](../usage.md#test) or evaluate them interactively using [`regula repl`](../usage.md#repl). For each rule to be tested, you'll need three files:

- The test Terraform or CloudFormation IaC file (aka test input)
- The Rego rule file
- The Rego tests file, where each test is prepended with `test_`

In both cases, note the path to the IaC file relative to where you invoke `regula test` or `regula run` should align with the package name imported into the Rego test file, as explained in [this note](#a-note-about-test-input).

#### Test a rule via `regula test`

To test one or more rules via [`regula test`](../usage.md#test):

```
regula test path/to/rule path/to/tests path/to/IaC
```

- Example:

        regula test rules/my_rule.rego tests/my_rule_test.rego infra/my_infra.tf

- Example:

        regula test .

You'll see output like this:

```
PASS: 142/142
```

#### Test a rule via `regula repl`

To test interactively test one or more rules via [`regula repl`](../usage.md#repl):

1. Load the tests, rule, and IaC files into the REPL:

        regula repl path/to/rule path/to/tests path/to/IaC

    Example:
    
        regula repl rules/my_rule.rego tests/my_rule_test.rego infra/my_infra.tf
        
    Example:
    
        regula repl .

2. Open the rule package:

        package rules.my_rule

3. Import the IaC package:

        import data.infra.my_infra_tf

4. Evaluate a test from your rule tests file:

        data.rules.my_rule.allow with input as my_infra_tf.mock_resources["aws_s3_bucket.my_valid_bucket"]

You'll see the result of the evaluation:

```
true
```

## Example rules

You can view the [Regula library of rules](https://github.com/fugue/regula/tree/master/rego/rules) and accompanying [tests](https://github.com/fugue/regula/tree/master/rego/tests/rules) for reference. You'll also find some [example rules](https://github.com/fugue/regula/tree/master/rego/examples/aws) in the repo.