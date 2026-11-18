# Bicep for Everyone

Atlanta, USA

[![GitHub](https://img.shields.io/badge/--181717?logo=github&logoColor=ffffff)](https://github.com/Cloud2BR-MSFTLearningHub)
[Cloud2BR OSS - Learning Hub](https://github.com/Cloud2BR-MSFTLearningHub)
[![Validation](https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/actions/workflows/validate-and-deploy.yml/badge.svg)](https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/actions/workflows/validate-and-deploy.yml)

Last updated: 2026-11-18

An original, practical Azure Infrastructure as Code learning platform:
beginner lessons, reusable Bicep modules, architecture labs, and an
environment-based project. These are learning building blocks, not certified
production landing zones.

[Read the website](https://cloud2br-msftlearninghub.github.io/Bicep-For-Everyone/) |
[Start learning](docs/getting-started.md) |
[Module catalog](docs/catalog.md) |
[Contribute](CONTRIBUTING.md)

<details>
<summary><b>Table of contents</b></summary>

- [Learning sequence](#learning-sequence)
- [Repository organization](#repository-organization)
- [First compilation](#first-compilation)
- [Deployment safety](#deployment-safety)
- [Validation and website](#validation-and-website)
- [Community and license](#community-and-license)

</details>

## Learning sequence

1. Understand [IaC, ARM, Bicep, and Terraform](docs/fundamentals.md).
2. [Install the tools](docs/getting-started.md) and compile a resource group.
3. Learn [parameters, variables, and functions](docs/parameters-expressions.md).
4. Compose [resources and modules](docs/resources-modules.md).
5. Review [validation and deployment](docs/deployment.md) before touching Azure.
6. Build a [hub-and-spoke or private web lab](docs/architectures.md).
7. Separate [environment parameters](docs/projects.md) and contribute improvements.

## Repository organization

The numbered Azure service categories follow the organizational idea of
[AzureTerraformTemplates-v0.0.0](https://github.com/Cloud2BR-MSFTLearningHub/AzureTerraformTemplates-v0.0.0).
All infrastructure here is original native Bicep, not copied Terraform.
Existing category numbers are retained; gaps do not imply missing placeholder modules.

| Directory | Working examples |
| --- | --- |
| `0_core-infrastructure/` | Resource group, VNet, subnet, NSG, public IP, routes |
| `1_storage-databases/` | Storage with blob/files/lifecycle, SQL, Cosmos DB, PostgreSQL |
| `2_compute-containers/` | Linux VM, VMSS, App Service, Functions, Container Apps, AKS |
| `3_networking/` | Private endpoint and private DNS |
| `4_identity-security/` | Key Vault, managed identity, role assignment |
| `5_analytics-bigdata/` | Event Hubs ingestion |
| `6_monitoring-management/` | Log Analytics, Application Insights, diagnostics, CPU alert |
| `8_ai-ml/` | Azure AI Services account |
| `9_migration-backup/` | Recovery Services vault foundation |
| `11_integration-services/` | Service Bus namespace and queue |
| `12_architecture-examples/` | Hub-and-spoke, private web, multi-tier network |
| `13_projects/` | Modular environment foundation with dev/prod parameter files |
| `docs/` | Lessons, canonical-source views, community documentation |
| `.github/` | Compile/lint, documentation validation, Pages, issue forms |

Every `main.bicep` has a README covering prerequisites, required inputs,
deployment, expected results, validation, cleanup, costs, and limitations.
The [catalog](docs/catalog.md) links to each complete source.

## First compilation

Install [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) and
the [Bicep VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep).
From the downloaded or cloned repository:

```shell
az bicep install
az bicep version
az bicep build --file 0_core-infrastructure/resource-group/main.bicep --stdout
```

Expected: ARM JSON with a resource-group declaration. This command does not log
in or create resources. See [getting started](docs/getting-started.md) for a
subscription-scoped deployment and cleanup.

## Deployment safety

**CI never deploys Azure resources.** Compilation checks types and syntax, not
regional availability, RBAC, quotas, live API behavior, network reachability,
runtime readiness, costs, or production fitness.

Most data services disable public networking and local key authentication.
Deploy their documented private networking and data-plane roles before expecting
applications to connect. A management-plane deployment can succeed while the
service remains intentionally unreachable.

Use a dedicated sandbox resource group, inspect `what-if`, review the
[security and cost guidance](docs/security-costs.md), and delete labs afterward.
Never commit credentials, private keys, live subscription IDs, or local parameters.

## Validation and website

The Material website uses full-width responsive navigation, breadcrumbs,
light/dark themes, navy headers/buttons, search, copy-code, Mermaid diagrams,
and the organization logo as its header icon and favicon. The visual design
matches [LaTeX for Everyone](https://brown9804.github.io/LaTeX-For-Everyone/).

```shell
python -m pip install -r requirements.txt
python .github/scripts/validate_bicep.py
python .github/scripts/generate_catalog.py --check
python -m mkdocs build --strict
python .github/scripts/check_site.py
```

GitHub Actions runs these checks and deploys documentation to Pages only after
successful validation on `main`. It installs the current Bicep CLI and records
the version in logs; new compiler warnings fail validation rather than being
silently ignored. Compiled ARM JSON is a workflow artifact, not committed code.
See [maintenance](docs/maintaining.md).

## Community and license

Read [CONTRIBUTING](CONTRIBUTING.md), [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md),
[CHANGELOG](CHANGELOG.md), and [CITATION](CITATION.cff).
The repository's existing [GPL-3.0 license](LICENSE) is preserved. Microsoft
documentation is linked, not redistributed. Organization branding belongs to
its respective owner.
