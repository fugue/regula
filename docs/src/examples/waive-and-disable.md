# Example: Waiving and Disabling Rules

With Regula, you can [waive](../configuration.md#waiving-rule-results) a rule for one or more specific resources, resource types, or even entire files. You can also [disable](../configuration.md#disabling-rules) a rule altogether so it isn't applied to any resource.

Just as you'd declare the resource itself in IaC, you can declare the waiver or disabled rule using Rego policy as code (and it's easy, too!).

In this example, we'll show you how.

## Prerequisites

We're going to run Regula on some sample IaC in our [regula-ci-example](https://github.com/fugue/regula-ci-example) repo.

If you completed the Getting Started [tutorial](../getting-started.md#tutorial-run-regula-locally-on-terraform-iac) and already cloned the example IaC, you can [skip to the next section](#running-regula-without-the-config-file).

1. [Install Regula](../getting-started.md#installation).

2. Clone the sample infrastructure repo:

        git clone https://github.com/fugue/regula-ci-example.git

3. Move into the `regula-ci-example` directory:

        cd regula-ci-example

## Running Regula without the config file

We'll start by running Regula without the config file.

We'll be running Regula on the [`regula-ci-example/infra_tf`](https://github.com/fugue/regula-ci-example/tree/master/infra_tf) Terraform project, and checking it against the Regula rule library and an example [custom rule](https://github.com/fugue/regula-ci-example/blob/master/example_custom_rule/long_description.rego).

Make sure you're in the `regula-ci-example` directory and run this command:

```
regula run -f json --include example_custom_rule infra_tf
```

We see this output:

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
    },
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22",
        "CIS-AWS_v1.3.0_1.16"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges",
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
        "CIS-AWS_v1.2.0_1.22",
        "CIS-AWS_v1.3.0_1.16"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "PASS",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
    <cut for length>
  ],
  "summary": {
    "filepaths": [
      "infra_tf/main.tf"
    ],
    "rule_results": {
      "FAIL": 2,
      "PASS": 4,
      "WAIVED": 0
    },
    "severities": {
      "Critical": 0,
      "High": 1,
      "Informational": 0,
      "Low": 1,
      "Medium": 0,
      "Unknown": 0
    }
  }
}
```

See how there are 2 FAIL results? One of these is for the resource `aws_iam_policy.basically_allow_all`, an IAM policy that has a very short description, which failed the rule `long_description` ("IAM policies must have a description of at least 25 characters").

Let's say we want to make an exception for this resource. We're going to waive the rule result!

## Writing the configuration file

Copy the configuration below into a file named `config.rego` in the root of the `regula-ci-example` directory:

```ruby
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "rule_name": "long_description",
    "resource_id": "aws_iam_policy.basically_allow_all"
  }
}
```

Let's dissect the config.

The package name must always be `fugue.regula.config`, so we start with that.

Then, to create a waiver, we declare a `waivers` set and add a `waiver` object to it. There are [many ways to configure a rule waiver](../configuration.md#waiving-rule-results), but in this case we're going to specify a `rule_name` (which is the package name minus the `rules.` part) and a `resource_id`.

This configuration will waive the rule `long_description` for the resource `aws_iam_policy.basically_allow_all`.

## Running Regula with the config file

Now, let's run Regula again. The command is identical to the previous one, but adds the config file: `--include config.rego`

Here's the full command:

```
regula run -f json --include example_custom_rule --include config.rego infra_tf
```

We see this output:

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
      "rule_result": "WAIVED",
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
    },
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22",
        "CIS-AWS_v1.3.0_1.16"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges",
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
        "CIS-AWS_v1.2.0_1.22",
        "CIS-AWS_v1.3.0_1.16"
      ],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "PASS",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    }
    <cut for length>
  ],
  "summary": {
    "filepaths": [
      "infra_tf/main.tf"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 4,
      "WAIVED": 1
    },
    "severities": {
      "Critical": 0,
      "High": 1,
      "Informational": 0,
      "Low": 0,
      "Medium": 0,
      "Unknown": 0
    }
  }
}
```

This time, there are 1 FAIL, 4 PASS, and 1 WAIVED rule results! You can see in the output that the `rule_result` value is `WAIVED` for the rule `long_description` and resource `aws_iam_policy.basically_allow_all`.

Hooray! You've just configured Regula to waive a rule result for a resource. Your next mission: disabling a rule!

## Disabling a rule

For demonstrative purposes, let's [disable](../configuration.md#disabling-rules) the rule `tf_aws_iam_admin_policy` ("IAM policies should not have full `"*:*"` administrative privileges"). We've decided that we don't want Regula to run this rule at all.

Add the following chunk to the end of `config.rego`:

```ruby
rules[rule] {
  rule := {
    "rule_name": "tf_aws_iam_admin_policy",
    "status": "DISABLED"
  }
}
```

Run the same command we ran a moment ago:

```
regula run -f json --include example_custom_rule --include config.rego infra_tf
```

We'll see this output:

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
      "rule_result": "WAIVED",
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
    <cut for length>
  ],
  "summary": {
    "filepaths": [
      "infra_tf/main.tf"
    ],
    "rule_results": {
      "FAIL": 0,
      "PASS": 3,
      "WAIVED": 1
    },
    "severities": {
      "Critical": 0,
      "High": 0,
      "Informational": 0,
      "Low": 0,
      "Medium": 0,
      "Unknown": 0
    }
  }
}
```

Now there are just 4 rule results: 3 PASS and 1 WAIVED. As you can see, the rule `tf_aws_iam_admin_policy` was totally ignored.

Nice job! You just configured Regula to disable a rule. 

## What's next?

Congratulations on finishing this example! :tada: To read more about waivers and disabling rules, see [Configuring Regula](../configuration.md). Or, see our example for [writing a rule](writing-a-rule.md).