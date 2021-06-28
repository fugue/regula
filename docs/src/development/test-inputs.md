# Test Inputs

Understanding how Regula handles inputs is key to developing your own rules, since the test input can be used to help you write the rule and the rule tests.

When Regula reads in an IaC file, it transforms the IaC into three types of JSON-formatted inputs:

- `mock_resources` -- **Used as input for [simple rules](writing-rules.md#simple-rules)**. It's an alias for `mock_input.resources`.
- `mock_input` -- **Used as input for [advanced rules](writing-rules.md#advanced-rules)**. It's a transformed representation of the `mock_config` known as the *resource view*.
- `mock_config` -- the raw JSON representation fed into OPA. Used as input when checking configuration outside of resources, such as provider config.

Regula dynamically generates each type of input at runtime when the IaC file is loaded, so you don't need to run a script to generate it. You can simply:

- Load the files into [`regula repl`](../usage.md#repl) to [view the test input](#viewing-test-inputs) and help you [write a rule](writing-rules.md) or [write a test](writing-tests.md)
- Load the files into [`regula repl`](../usage.md#repl) to [interactively evaluate tests](testing-rules.md#test-a-rule-via-regula-repl)
- Load the files into [`regula test`](../usage.md#test) to [run the tests](testing-rules.md#test-a-rule-via-regula-test)

## A note about test input package names

The package name for the test input is based on its path, relative to where you'll be running [`regula repl`](../usage.md#repl) or [`regula test`](../usage.md#test). Regula automatically generates the package name, replacing path separators with `.` and other characters (such as dashes) with `_`

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

## Viewing test inputs

You can easily view each type of test input for an IaC file by following the steps below:

1. Load the IaC file or directory of files into [`regula repl`](../usage.md#repl). Example:

        regula repl infra

2. Enter the package name of the input type you want to view, following this pattern (as explained [above](#a-note-about-test-input-package-names)):

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