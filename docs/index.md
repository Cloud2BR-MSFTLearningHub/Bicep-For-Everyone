# Bicep for Everyone

[Cloud2BR OSS - Learning Hub](https://github.com/Cloud2BR-MSFTLearningHub) | Atlanta, USA

<div class="learning-intro" markdown>

**From your first Azure resource to reusable infrastructure patterns.**

Learn the concepts, inspect real Bicep, compile without an Azure account,
and deploy only when you understand the security and cost implications.

[Start learning](getting-started.md){ .md-button .md-button--primary }
[Explore modules](catalog.md){ .md-button }

</div>

## Find your next step

| Your goal | Start here | Continue with |
| --- | --- | --- |
| Understand infrastructure as code | [Fundamentals](fundamentals.md) | [First compilation](getting-started.md) |
| Replace repeated configurations | [Parameters and functions](parameters-expressions.md) | [Reusable modules](resources-modules.md) |
| Build Azure resources | [Module catalog](catalog.md) | [Service selection](services.md) |
| Connect services privately | [Security and costs](security-costs.md) | [Architecture labs](architectures.md) |
| Separate dev and prod inputs | [Environment project](projects.md) | [Validation](deployment.md) |
| Resolve a failure | [Troubleshooting](troubleshooting.md) | [Official resources](resources.md) |

## How this platform works

- **Learn:** beginner-to-advanced Markdown lessons explain the reasoning.
- **Inspect:** module pages embed the actual repository source at build time.
- **Compile:** validation produces ARM JSON and runs the Bicep analyzer.
- **Plan:** authenticated validation and what-if are explicit learner actions.
- **Deploy:** only you choose to create paid resources.
- **Clean up:** every module documents deletion and service-specific limitations.

## What is verified

CI checks compilation, linting, documentation synchronization, the strict
website build, and generated links. It does **not** deploy Azure resources or
certify runtime behavior, production security, cost, or service availability.
Private-by-default modules often need endpoints, DNS, roles, and application
configuration before a data-plane connection can work.

Use the [learning paths](learning-paths.md), [contribution guide](contributing.md),
and [community standards](code-of-conduct.md) to participate.
