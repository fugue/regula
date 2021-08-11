# Regula Pre-Commit Hook

You can run Regula in a [pre-commit](https://pre-commit.com/) hook. Whenever you `git commit` IaC, Regula will check it for security and compliance first. If there are violations, you'll need to remediate them before you can commit the code.

The pre-commit hook below:

- Checks changed Terraform HCL files anywhere in the local repo
- Checks changed CloudFormation templates in `/src`
- Outputs test results in TAP format

## Hook installation

1. Install pre-commit:

    ```
    pip install pre-commit
    ```

2. Copy the code below and save it as `.pre-commit-config.yaml` in the root of the repo you want to check:

    ```yaml
    repos:
      - repo: local
        hooks:
        - id: regula-cfn
          name: Regula for CloudFormation
          entry: regula run -f tap -t cfn
          language: system
          files: ^src/.*(yaml)$
      - repo: local
        hooks:
        - id: regula-tf
          name: Regula for Terraform HCL
          entry: regula run -f tap -t tf
          language: system
          files: .*(tf)
    ```

3. Install the pre-commit hook:

    ```
    pre-commit install
    ```

4. *Optional (but recommended!):* Test the hook on all IaC in the repo:

        pre-commit run --all-files

When you commit IaC now, Regula will check it for security and compliance issues.

## Example output

```tap
± git commit -m "Update network security rule"
Regula for CloudFormation................................................Passed
Regula for Terraform HCL.................................................Failed
- hook id: regula-tf
- exit code: 1

ok 0 azurerm_network_security_group.devnsg: Network security group rules should not permit ingress from '0.0.0.0/0' to port 3389 (Remote Desktop Protocol)
not ok 1 azurerm_network_security_group.devnsg: Network security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH)
ok 2 azurerm_storage_account.main: Storage Accounts 'Secure transfer required' should be enabled
ok 3 azurerm_storage_account.main: Storage accounts should deny access from all networks by default
ok 4 azurerm_storage_account.main: Storage accounts 'Trusted Microsoft Services' access should be enabled
```