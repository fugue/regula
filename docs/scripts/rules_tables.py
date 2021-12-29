import argparse
from dataclasses import dataclass
import json
import os
from typing import Dict, List, Optional, Tuple
from pytablewriter import MarkdownTableWriter

# Define --provider argument, set default to all
parser = argparse.ArgumentParser(
    description="Generate Regula Rules Documentation",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument(
    "--provider",
    default="all",
    help="Rule provider",
)

# Each rule's metadata contains severity, id, title, provider, resource types
@dataclass
class RuleMeta:
    """
    Metadata for a single rule
    """

    severity: str
    id: str
    title: str
    provider: str
    resource_types: List[str]
    # controls: Optional[Dict[str, Dict[str, List[str]]]]
    # description: str
    # service: Optional[str]
    # input_type: Optional[str]


# Detect provider; preserved for future functionality
# def detect_provider(name: str) -> Tuple[Optional[str], Optional[str]]:
#     parts = name.split("_", 2)
#     if len(parts) < 3:
#         return (None, None)
#     if parts[0] == "cfn":
#         return ("aws", "cloudformation")
#     if parts[0] == "arm":
#         return ("azure", "arm")
#     elif parts[0] == "tf":
#         return (parts[1], "terraform")
#     return (None, None)


# Get the path to the rule provider directory
def get_provider_dir(provider:str) -> str:
    if provider == "cfn" or provider == "arm" or provider == "k8s":
        provider_dir = os.path.join("rego", "rules", provider)
    elif provider == "aws" or provider == "azurerm" or provider == "google":
        provider_dir = os.path.join("rego", "rules", "tf", provider)
    return provider_dir


# Recurse through each rule provider directory and make a list of rule paths
def get_files(provider: str) -> List[str]:
    rule_defs = list()
    provider_dir = get_provider_dir(provider)
    if provider == "k8s":
        rule_paths = os.listdir(provider_dir)
        for rule_path in rule_paths:
            rule = os.path.join(provider_dir, rule_path)
            rule_defs.append(rule)
    else:
        service_dirs = os.listdir(provider_dir)
        for service_dir in service_dirs:
            service_path = os.path.join(provider_dir, service_dir)
            rule_paths = os.listdir(service_path)
            for rule_path in rule_paths:
                rule = os.path.join(service_path, rule_path)
                rule_defs.append(rule)
    return rule_defs


# Read metadata for each rule
def read_metadata(provider: str) -> List[RuleMeta]:
    rule_defs = get_files(provider)
    rules: List[RuleMeta] = []
    for rule_filename in rule_defs:
        rule_meta = {}
        with open(rule_filename) as f:
            rule_lines = f.readlines()
        for line in rule_lines:
            line = line.strip()
            if line.startswith('"id":'):
                rule_meta["id"] = line.split(maxsplit=1)[1].strip('",')
            elif line.startswith('"title":'):
                rule_meta["title"] = line.split(maxsplit=1)[1].strip('",')
            elif line.startswith('"severity":'):
                rule_meta["severity"] = line.split(maxsplit=1)[1].strip('",')
            elif line.startswith("resource_type"):
                rule_meta["resource_type"] = line.split("= ")[1].strip('"')
        rules.append(
            RuleMeta(
                severity=rule_meta["severity"],
                id=rule_meta["id"],
                title=rule_meta["title"],
                provider=provider,
                resource_types=rule_meta["resource_type"],
            )
        )
    return rules


# Group rules
def group_rules(rules: List[RuleMeta]) -> Dict[str, List[RuleMeta]]:
    by_provider: Dict[str, List[RuleMeta]] = {}
    for rule in rules:
        provider_rules = by_provider.setdefault(rule.provider, [])
        provider_rules.append(rule)
    for provider, provider_rules in by_provider.items():
        provider_rules.sort(key=lambda r: r.id)
    return by_provider


# Write rules table
def write_rules_table(header: str, rules: List[RuleMeta]):
    writer = MarkdownTableWriter(
        table_name=header,
        headers=[
            "Summary",
            "Resource Types",
            "Severity",
            "Rule ID",
        ],
        value_matrix=[
            [
                rule.title,
                rule.resource_types if rule.resource_types else "",
                rule.severity,
                rule.id,
            ]
            for rule in rules
        ],
    )
    writer.inc_indent_level()
    writer.write_table()


# Provider abbreviations and definitions
provider_name_map: Dict[str, str] = {
    "aws": "AWS (Terraform)",
    "cfn": "AWS (CloudFormation)",
    "azurerm": "Azure (Terraform)",
    "arm": "Azure (Azure Resource Manager)",
    "google": "Google",
    "k8s": "Kubernetes"
}


def main():
    args = parser.parse_args()

    # If --provider is set to all, write table for all providers
    if args.provider == "all":
        for provider_name in provider_name_map:
            rule_metadata = read_metadata(provider_name)
            grouped_rules = group_rules(rule_metadata)
            for provider_name, provider_rules in grouped_rules.items():
                write_rules_table(provider_name_map[provider_name], provider_rules)
                print()
    # Otherwise, print table for specified --provider
    else:
        rule_metadata = read_metadata(args.provider)
        grouped_rules = group_rules(rule_metadata)
        for provider, provider_rules in grouped_rules.items():
            write_rules_table(provider_name_map[provider], provider_rules)
            print()


if __name__ == "__main__":
    main()
