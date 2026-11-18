# Bicep fundamentals

## Infrastructure as Code

IaC describes infrastructure in reviewable text rather than relying on a
sequence of portal clicks. You can version changes, reuse patterns, and compare
environments. It does not remove the need for approvals, permissions, operations,
or cost controls.

## Azure Resource Manager

ARM is Azure's management plane. It authenticates deployment requests,
evaluates scope and policy, resolves dependencies, and asks resource providers
to create or update resources. A storage-account resource and a blob uploaded
into it are different operations; the latter also needs data-plane access.

## What Bicep does

Bicep is a declarative, Azure-focused language compiled to ARM JSON. Write
the desired resources and relationships; do not write imperative retry loops
to wait for a dependent resource. Bicep/ARM track resource dependencies.
Repeated incremental deployment aims to converge declared resources, but does
not make every provider update side-effect-free.

## Bicep, ARM JSON, and Terraform

| Aspect | Bicep | ARM JSON | Terraform |
| --- | --- | --- | --- |
| Authoring | Concise Azure DSL | Verbose JSON template | HCL and providers |
| Execution | Compiles to ARM deployments | ARM deployments | Terraform plan/apply and provider APIs |
| State | Uses Azure resource/deployment state; no separate Bicep state file | Same ARM model | Usually a protected remote state backend |
| Scope | Azure | Azure | Multiple providers and clouds |
| Reuse | Local/registry modules | Nested/linked templates | Modules |

Choose based on your team's operating model, not line count. Terraform still
uses Azure APIs and needs careful state handling. Bicep still needs drift
review and secure deployment identities. This repository complements the
[Terraform examples](https://github.com/Cloud2BR-MSFTLearningHub/AzureTerraformTemplates-v0.0.0)
without translating or copying their implementation.

## Safe expectations

Incremental mode does not delete a resource merely because you removed its
declaration, but declared properties and child-resource ownership still need
careful review. Learn deployment stacks and deletion semantics before adopting
them; never use destructive modes casually.

**Exercise:** explain why compilation can succeed even when a subscription
lacks VM quota. Answer: type checking does not consult the live subscription.
