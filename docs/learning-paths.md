# Learning paths

## Beginner: understand before deploying

1. Read [fundamentals](fundamentals.md) and explain desired state in your own words.
2. [Install the tools](getting-started.md) and compile the resource-group example.
3. Change a parameter default and inspect the resulting ARM JSON.
4. Study the VNet and managed-identity entries in the [catalog](catalog.md).
5. Explain why successful compilation does not prove deployment permissions.

**Checkpoint:** identify a parameter, resource type/API version, resource name,
scope, and output without deploying anything.

## Intermediate: compose and operate

Read [parameters and expressions](parameters-expressions.md), then
[resources and modules](resources-modules.md). Compare storage, private endpoint,
and RBAC modules. Follow [deployment](deployment.md) in a dedicated sandbox,
if authorized. Confirm a private DNS lookup from the intended client network.

**Checkpoint:** show the dependency chain and explain why a resource ID output
is different from a credential or granted permission.

## Advanced: architecture and environment boundaries

Inspect [architecture patterns](architectures.md) and the [environment project](projects.md).
Create a separate local parameter file, review every what-if difference,
estimate cost, and document a connectivity test and cleanup plan.

**Checkpoint:** distinguish implemented infrastructure from requirements that
still need an application, identity assignment, private client, or live test.
