# Getting Started

## Installation

### Homebrew (macOS & Linux)

To install Regula via [Homebrew](https://brew.sh/):

```
brew tap fugue/regula
brew install regula
```

To upgrade Regula:

```
brew upgrade regula
```

### Prebuilt binary (all platforms)

1. Download the Regula archive for your platform from the [Releases](https://github.com/fugue/regula/releases) page.
2. Extract the downloaded archive.
3. Move the extracted `regula` binary to somewhere in your PATH:

    === "macOS"

        ```shell
        mv regula /usr/local/bin
        ```

    === "Linux"

        ```shell
        sudo mv regula /usr/local/bin
        ```

    === "Windows (cmd)"

        ```
        md C:\regula\bin
        move regula.exe C:\regula\bin
        setx PATH "%PATH%;C:\regula\bin"
        ```
    
    === "Windows (PowerShell)"

        ```powershell
        md C:\regula\bin
        move regula.exe C:\regula\bin
        $env:Path += ";C:\regula\bin"
        # You can add '$env:Path += ";C:\regula\bin"' to your profile.ps1 file to
        # persist that change across shell sessions.
        ```

4. _Windows users only:_ Close cmd and re-open it so the changes take effect.
5. You can now run `regula`.

!!! note
    On some versions of macOS, you might see an error message that "regula cannot be opened because the developer cannot be verified." You can safely run regula by taking the following steps:

    1. Select "Cancel" to dismiss the error message.
    2. In macOS, access System Preferences > Security & Privacy.
    3. Select the General tab and click the "Allow Anyway" button.
    4. Run regula again:

            regula

    5. macOS will ask you to confirm that you want to open it. Select "Open."
    
    You can now execute regula commands.

### Docker (all platforms)

!!! note
    Windows users can run Linux containers using a method described in the [Microsoft documentation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/linux-containers).

Regula is available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

For usage, see [Running Regula with Docker](usage.md#running-regula-with-docker).

## Tutorial: Run Regula locally on Terraform IaC

!!! tip
    Don't need a tutorial? Jump ahead to [Usage](usage.md).

For this example, we'll be running Regula on some example Terraform infrastructure as code (IaC) in our [regula-ci-example](https://github.com/fugue/regula-ci-example) repo.

1. Clone the example IaC repo:

        git clone https://github.com/fugue/regula-ci-example.git

2. Move into the `regula-ci-example` directory:

        cd regula-ci-example

3. Run Regula against the [example Terraform](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf):

        regula run infra_tf

You'll see output like this:

```
FG_R00092: IAM policies should not have full "*:*" administrative privileges [High]
           https://docs.fugue.co/FG_R00092.html

  [1]: aws_iam_policy.basically_allow_all
       in infra_tf/main.tf:6:1

Found one problem.
```

Looks like there is one problem with the Terraform! Let's get a full JSON report.

### Dig into the details

To get a full JSON report, run Regula with the `-f json` flag:

    regula run infra_tf -f json

You'll see output like this:

```json
{
  "rule_results": [
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
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00092.html",
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
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00092.html",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
    {
      "controls": [],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not allow broad list actions on S3 buckets. Should a malicious actor gain access to a role with a policy that includes broad list actions such as ListAllMyBuckets, the malicious actor would be able to enumerate all buckets and potentially extract sensitive data.",
      "rule_id": "FG_R00218",
      "rule_message": "",
      "rule_name": "tf_aws_iam_s3_nolist",
      "rule_result": "PASS",
      "rule_severity": "Medium",
      "rule_summary": "IAM policies should not allow broad list actions on S3 buckets",
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00218.html",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
    {
      "controls": [],
      "filepath": "infra_tf/main.tf",
      "input_type": "tf",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not allow broad list actions on S3 buckets. Should a malicious actor gain access to a role with a policy that includes broad list actions such as ListAllMyBuckets, the malicious actor would be able to enumerate all buckets and potentially extract sensitive data.",
      "rule_id": "FG_R00218",
      "rule_message": "",
      "rule_name": "tf_aws_iam_s3_nolist",
      "rule_result": "PASS",
      "rule_severity": "Medium",
      "rule_summary": "IAM policies should not allow broad list actions on S3 buckets",
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00218.html",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 6,
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
      "PASS": 3,
      "WAIVED": 0
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

### What does it mean?

Regula just showed us that our [sample Terraform](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf) is noncompliant and a security vulnerability. In this example, there are 4 rule results: 3 PASS and 1 FAIL.

The AWS IAM policy resource `aws_iam_policy.basically_allow_all` failed the Regula rule ["IAM policies should not have full `"*:*"` administrative privileges."](https://github.com/fugue/regula/blob/master/rego/rules/tf/aws/iam/admin_policy.rego) The report includes lots of other info, such as the filepath, line, and column the resource was found in; the rule severity; a full description of the rule; and more:

```json
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
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00092.html",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 6,
          "column": 1
        }
      ]
    },
```

In contrast, the policy `aws_iam_policy.basically_deny_all` passed the rule:

```json
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
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00092.html",
      "source_location": [
        {
          "path": "infra_tf/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
```

The summary lists the filenames evaluated, the number of FAIL/PASS/[WAIVED](configuration.md#waiving-rule-results) rule results, and the severity of the failed rules:

```json
  "summary": {
    "filepaths": [
      "infra_tf/main.tf"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 3,
      "WAIVED": 0
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

## What's next?

Congratulations on finishing this example! :tada: Now, [learn more about how to use Regula](usage.md).
