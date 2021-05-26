# Configuring Regula

!!! tip
    For a tutorial on configuring Regula, see [Example: Waiving and Disabling Rules](examples/waive-and-disable.md).

Regula can be configured to [waive](#waiving-rule-results) rule results or [enable/disable](#disabling-rules) rules altogether in Rego files that have the following package name set:

    package fugue.regula.config

You can either pass a specific Regula config file to [`regula run`](usage.md#run):

    regula run --include config.rego my_infra

Or a directory that includes your other Rego rules and libraries:

    regula run --include my_rego_stuff my_infra

## Waiving rule results

Regula enables you to waive a rule for resources or rules that match certain attributes.  When a rule is waived for a resource, the result (`PASS` or `FAIL`) becomes `WAIVED` and is effectively ignored in compliance calculations.

The following rule result attributes, which are also in the [Regula report output](report.md), are supported for waiver objects:

 -  `resource_id`: The ID of the resource (defaults to `*`)
 -  `resource_type`: The resource type of the resource (e.g. `aws_s3_bucket` for Terraform, or `AWS::S3::Bucket` for CloudFormation)
 -  `rule_id`: The metadata ID of the rule (defaults to `*`)
 -  `rule_name`: The package name of the rule (defaults to `*`). Omit the `rules.` segment of the package name (e.g., use `cfn_vpc_ingress_22` rather than `rules.cfn_vpc_ingress_22`)
 -  `filepath`: The filepath containing the resource, as passed to Regula (defaults to `*`)

If an attribute is not specified for a waiver, Regula assumes a `*` value. Note that `rule_id` and `rule_name` can both be used as identifiers for a given rule. 

To add a waiver, add a waiver object to the `waivers` set in `fugue.regula.config`:

```rego
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "rule_id": "FG_R00100",
    "resource_id": "LoggingBucket"
  }
}
```

The above example waives a single resource for a single rule. 

It is also possible to waive this rule for all resources:

```rego
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "rule_id": "FG_R00100"
  }
}
```

In this example, because `resource_id` is omitted, its default value `*` is assumed.

You can configure multiple waivers by adding to the `waivers` set in `fugue.regula.config`:

```rego
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "filepath": "../my-test-infra/infra_cfn/cloudformation.yaml",
    "resource_id": "InvalidUser01"
  } 
} {
  waiver := {
    "resource_type": "google_compute_subnetwork"
  }
}
```

## Disabling rules

Disabling a rule prevents Regula from running the rule at all. This can be used to remove rules that are not relevant for your purposes.

To disable a rule, add an object to the `rules` set in `fugue.regula.config` and use `DISABLED` for `status`.

You can disable rules by `rule_name` (rule package name, omitting the `rules.` segment) or by `rule_id`.

Here's an example using `rule_id`:

```rego
package fugue.regula.config

rules[rule] {
  rule := {
    "rule_id": "FG_R00100",
    "status": "DISABLED"
  }
}
```

Below is an example using `rule_name`. Note that the `rules.` segment of the package name must be omitted, so we use `cfn_vpc_ingress_22` rather than `rules.cfn_vpc_ingress_22`.

!!! tip
    You can find the `rule_name` by running Regula first and looking for `rule_name` in the report.

```rego
package fugue.regula.config

rules[rule] {
  rule := {
    "rule_name": "cfn_vpc_ingress_22",
    "status": "DISABLED"
  }
}
```

You can disable multiple rules by adding to the `rules` set in `fugue.regula.config`:

```rego
package fugue.regula.config

rules[rule] {
  rule := {
    "rule_id": "FG_R00007",
    "status": "DISABLED"
  }
} {
  rule := {
    "rule_name": "tf_aws_iam_admin_policy",
    "status": "DISABLED"
  }
}
```

## Waive or disable?

When should you waive a rule and when should you disable it?

- If there's a good reason a rule shouldn't apply to a particular resource, you can create a [waiver](#waiving-rule-results) for that rule result. This is useful for making exceptions to rules.
- If a rule shouldn't apply to *any* resource, you can [disable](#disabling-rules) it. This is useful if a rule is not relevant at all for your organization.

For instance, if you have an S3 bucket that hosts a static website, you can waive the rule ["S3 buckets should have all `block public access` options enabled"](https://github.com/fugue/regula/blob/master/rego/rules/cfn/s3/block_public_access.rego) for that bucket because it's *intentionally* public. The rule will still be applied to all your other S3 buckets, but the website bucket will have a rule result of WAIVED instead of PASS or FAIL.

In contrast, if you don't want the "block public access" rule applied to *any* S3 bucket, you can disable it and Regula will ignore the rule. No rule results will be calculated, and therefore the rule won't be included in Regula's report.

(You could alternatively waive the rule for all resources, in which case you'd still see a WAIVE value for each rule result in Regula's report.)