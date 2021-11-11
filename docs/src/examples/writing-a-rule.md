# Example: Writing a Simple Rule

Regula supports writing custom rules written in the [Rego](https://www.openpolicyagent.org/docs/latest/policy-language/) language (and we welcome community [contributions](../contributing.md)!)

In this example, we'll walk through a [simple custom rule](../development/writing-rules.md#simple-rules) line by line, using the sample rule `long_description` in the [regula-ci-example](https://github.com/fugue/regula-ci-example/blob/master/example_custom_rule/long_description.rego) repo.

This walkthrough demonstrates a Terraform rule, but at the end we'll show you the [CloudFormation equivalent](#cloudformation-example-rule).

## Allow or deny?

We're going to write a [**simple rule**](../development/writing-rules.md#simple-rules) that checks whether an AWS IAM policy description is 25 characters or more. If so, the resource passes the test. If not, it fails.

Simple rules must specify `allow` or `deny`. It's only necessary to specify one or the other, because anything not explicitly allowed is implicitly denied, and vice versa.

We can rephrase this rule as "**Allow** a resource if its description is 25 or more characters." So, we'll write an `allow` rule.

## Package declaration

First, we declare the package name. It should be unique, and it **must** start with `rules.` as we've done here:

```ruby
package rules.long_description
```

## Regula metadata

Adding metadata is optional but strongly encouraged, as it will make Regula's report much more useful:

```ruby
__rego__metadoc__ := {
  "id": "CUSTOM_0001",
  "title": "IAM policies must have a description of at least 25 characters",
  "description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
  "custom": {
    "controls": {
      "CORPORATE-POLICY": [
        "CORPORATE-POLICY_1.1"
      ]
    },
    "severity": "Low"
  }
}
```

For details on each of these attributes, see [Adding rule metadata](../development/writing-rules.md#adding-rule-metadata).

## Specify the resource type(s)

Next, specify the Terraform resource type. For simple rules, there must be exactly one `resource_type` declared, and in this case, that's [`aws_iam_policy`](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy):

```ruby
resource_type = "aws_iam_policy"
```

## Set the default value

When evaluating a rule with [OPA](https://www.openpolicyagent.org/docs/latest/), if no matches are found in the input, the return value isn't `false` -- it is `undefined`.

However, Regula expects a `false` rather than `undefined` value. We can provide an explicit `false` by setting a default value:

```ruby
default allow = false
```

This way, if the input doesn't contain any resources that meet the `allow` conditions (i.e., would return `true`), the return value is `false` instead of `undefined`.

## Write the `allow` rule

If you're not very familiar with Rego, here's a tip. You can restate a Rego rule like so:

```ruby
this variable = this value {
  if this condition is met
}
```

That means we can start with a skeleton of the `allow` rule (using some pseudocode):

```ruby
allow = true {
  if this condition is met
}
```

In Rego, the default value given to a variable in the head of a rule is `true`, so you can omit the `= true` in this case:

```ruby
allow {
  if this condition is met
}
```

Now we just need the condition. In this case, we want to allow a resource **if** its description is 25 characters or more.

### Specify the attribute(s) to check

First, we check how to specify the "description" attribute. The best way to do this is to check the [`mock_resources`](../development/test-inputs.md) dynamically generated from the test IaC file. In this case, we'll use [infra_tf/main.tf](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf) as our test file.

To view the `mock_resources`, let's fire up the [REPL](../usage.md#repl):

```
regula repl infra_tf
```

Now, we enter the package name of the input file, specifying `mock_resources` as the input type. The package name follows the format `data.<path.to.file>.<iac filename without extension>_<extension>.<input type>` so we'll enter the following:

```
data.infra_tf.main_tf.mock_resources
```

For more details on the package name format, see [our note about test inputs](../development/test-inputs.md#a-note-about-test-input-package-names).

You'll see this output:

```json
{
  "aws_iam_policy.basically_allow_all": {
    "_provider": "aws",
    "_type": "aws_iam_policy",
    "description": "Some policy",
    "id": "aws_iam_policy.basically_allow_all",
    "name": "some_policy",
    "path": "/",
    "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"*\",\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
  },
  "aws_iam_policy.basically_deny_all": {
    "_provider": "aws",
    "_type": "aws_iam_policy",
    "description": "Some policy with a long description that denies anything",
    "id": "aws_iam_policy.basically_deny_all",
    "name": "some_policy",
    "path": "/",
    "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
  }
}
```

Here you can see that there are two resources defined, both of the type `aws_iam_policy`. The attribute `description` is what we're looking for, and it's located at the level directly beneath the resource ID. That means it's a top-level attribute -- it's not nested under any other attribute.

If you'd like to learn more about using the REPL for developing rules, take a detour to [Test Inputs](../development/test-inputs.md).

### Specify the condition

With simple rules, we always preface the attribute with `input.` because it represents the resource currently being examined by Regula. So now we have this:

```ruby
input.description
```

We can use the Rego built-in function [`count(collection_or_string)`](https://www.openpolicyagent.org/docs/latest/policy-reference/#aggregates) to check how many characters are in a string. Because we only want to allow strings that are 25 characters or more, our rule logic looks like this:

```ruby
  count(input.description) >= 25
```

And when we put the condition inside the `allow` rule, we get this:

```ruby
allow {
  count(input.description) >= 25
}
```

## Put it all together

Now, here's the complete rule:

```ruby
package rules.long_description

__rego__metadoc__ := {
  "id": "CUSTOM_0001",
  "title": "IAM policies must have a description of at least 25 characters",
  "description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
  "custom": {
    "controls": {
      "CORPORATE-POLICY": [
        "CORPORATE-POLICY_1.1"
      ]
    },
    "severity": "Low"
  }
}

resource_type = "aws_iam_policy"

default allow = false

allow {
  count(input.description) >= 25
}
```

Great! You've written a simple Rego rule to check whether an IAM policy description is 25 characters or more in length.

Let's take Regula for a spin and try out our new rule.

## Running the rule with Regula

You can use Regula to check your Terraform IaC against this rule if you clone the [regula-ci-example](https://github.com/fugue/regula-ci-example) repo.

### Prerequisites

If you completed the Getting Started [tutorial](../getting-started.md#tutorial-run-regula-locally-on-terraform-iac) and already cloned the example IaC, you can [skip to the next section](#run-regula).

1. [Install Regula](../getting-started.md#installation).

2. Clone the sample infrastructure repo:

        git clone https://github.com/fugue/regula-ci-example.git

3. Move into the `regula-ci-example` directory:

        cd regula-ci-example

### Run Regula

Make sure you're in the `regula-ci-example` directory and use the following command to check the sample Terraform project in [`regula-ci-example/infra_tf/main.tf`](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf) against our custom rule, [`long_description.rego`](https://github.com/fugue/regula-ci-example/blob/master/example_custom_rule/long_description.rego):

```
regula run -f json --no-built-ins --include example_custom_rule infra_tf
```

Note that we've used the `--no-built-ins` option because we want to test _only_ this custom rule. We don't need to apply Regula's library of rules.

You'll see this output:

```json
{
  "rule_results": [
    {
      "controls": [
        "CORPORATE-POLICY_1.1"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
      "rule_id": "CUSTOM_0001",
      "rule_message": "",
      "rule_name": "long_description",
      "rule_raw_result": false,
      "rule_result": "FAIL",
      "rule_severity": "Low",
      "rule_summary": "IAM policies must have a description of at least 25 characters",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 6,
          "column": 1
        }
      ]
    },
    {
      "controls": [
        "CORPORATE-POLICY_1.1"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
      "rule_id": "CUSTOM_0001",
      "rule_message": "",
      "rule_name": "long_description",
      "rule_raw_result": true,
      "rule_result": "PASS",
      "rule_severity": "Low",
      "rule_summary": "IAM policies must have a description of at least 25 characters",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    }
  ],
  "summary": {
    "filepaths": [
      "infra_tf/main.tf"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 1,
      "WAIVED": 0
    },
    "severities": {
      "Critical": 0,
      "High": 0,
      "Informational": 0,
      "Low": 1,
      "Medium": 0,
      "Unknown": 0
    }
  }
}
```

As you can see, the IAM policy `aws_iam_policy.basically_deny_all` passed the custom rule because its description is long enough, and `aws_iam_policy.basically_allow_all` failed because its description is too short. Check out the [Terraform itself](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf) and you can confirm it.

## CloudFormation example rule

The process for writing custom rules to check CloudFormation is mostly the same as for Terraform -- the main difference is how you specify the resource type and attribute to check. Additionally, you need to specify `input_type := "cfn"` somewhere in the rule.

For instance, this is how you'd write `long_description` as a CloudFormation rule. Note that `resource_type` and `Description` are different from the Terraform rule, and `input_type` is present:

```ruby
package rules.long_description_cfn

__rego__metadoc__ := {
  "id": "CUSTOM_0001",
  "title": "IAM policies must have a description of at least 25 characters",
  "description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
  "custom": {
    "controls": {
      "CORPORATE-POLICY": [
        "CORPORATE-POLICY_1.1"
      ]
    },
    "severity": "Low"
  }
}

input_type := "cfn"

resource_type = "AWS::IAM::ManagedPolicy"

default allow = false

allow {
  count(input.Description) >= 25
}
```

## What's next?

Congratulations, you wrote a simple custom rule! :tada: To learn more about writing rules, check out [Writing Rules](../development/writing-rules.md). Or, continue onward to learn how to [debug](debug-tutorial.md) your rules.