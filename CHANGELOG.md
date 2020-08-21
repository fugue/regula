# CHANGELOG

 -  0.5.0 (2020-08-21)
     *  New rule: Ensure AWS S3 Buckets are encrypted.
     *  New rule: Ensure AWS CloudFront uses HTTPS.
     *  Allow `deny[msg]` style simple rules.
     *  Enable structured output for `conftest` integration.

 -  0.4.0 (2020-07-07)
     *  Relicense under Apache 2.0 rather than AGPL.
     *  Add `NIST_800-53` mapping to existing rules.
     *  Add support for `fugue.deny_resource_with_message` and
        `fugue.missing_resource_with_message` to return custom messages from
        rules.
     *  Add a workaround for a bug in OPA >= 0.20 that prevented simple
        `allow`/`deny` rules from working.
     *  Fix an issue where multiple terraform refs would cause an
        `object keys must be unique` error.

 -  0.3.0 (2020-03-11)
     *  Add conftest integration.
     *  Add a human-readable message to the report.

 -  0.2.0 (2020-02-25)
     *  Work around terraform issue with subdirectories & remote backends.
     *  Add initial set of Azure rules.
     *  Add initial set of GCP rules.
     *  Minor README.md and SECURITY.md fixes and improvements.

 -  0.1.0 (2020-01-23)
     *  Add support for terraform modules.
     *  Fix `mktemp` invocation on Mac.
     *  Various README improvements.

 -  0.0.1 (2020-01-14)
     *  Initial release.
