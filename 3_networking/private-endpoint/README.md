# Private endpoint

**Level:** Intermediate

## Overview and purpose

Create a private endpoint and DNS zone group for one existing service subresource.

## Azure services and dependencies

Read [main.bicep](https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/blob/main/3_networking/private-endpoint/main.bicep) for the exact resource types,
supported API versions, decorators, and outputs. No secret values are required
or emitted by this module.

## Prerequisites

Install Azure CLI and Bicep, authenticate to the intended subscription, and
confirm `az account show` before executing cloud commands.
Provide the correct target ID, service group ID, subnet, and service-specific private DNS zone linked to the client VNet.

Use the repository root as the working directory. Commands below use Bash
(Azure Cloud Shell works); PowerShell variable syntax differs.
Set `RG` to a dedicated existing sandbox group (except for the subscription-scoped
resource-group example), and `LOCATION` to an approved Azure region.
Set shell variables `NAME`, `SUBNET_ID`, `TARGET_RESOURCE_ID`, `GROUP_ID`, `PRIVATE_DNS_ZONE_ID` to your own approved values.
For array/object inputs, put valid JSON in the corresponding quoted variable.
Never use example IDs as real principal/resource IDs.

## Important parameters

| Parameter | Type | Requirement |
| --- | --- | --- |
| `name` | `string` | Required |
| `location` | `string` | Optional; see source default |
| `subnetId` | `string` | Required |
| `targetResourceId` | `string` | Required |
| `groupId` | `string` | Required |
| `privateDnsZoneId` | `string` | Required |

Descriptions and defaults live beside each declaration in the canonical source.
Names must meet the individual Azure service's naming rules.

## Bicep source and usage

[View the complete source](https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/blob/main/3_networking/private-endpoint/main.bicep).
Reference this module from another Bicep file with a relative module path and
a `params` object. The resources/modules lesson shows composition and dependencies.

## Compile and validate locally

```bash
az bicep build --file 3_networking/private-endpoint/main.bicep --stdout
```

Compilation and linting need no Azure login and create no resources. A successful
compile is not evidence that a deployment or application has been tested.

## Deployment instructions

These are opt-in cloud operations, never routine CI steps. Review policy,
permissions, region, quotas, dependencies, and price before proceeding.

```bash
az deployment group validate --resource-group "$RG" --template-file 3_networking/private-endpoint/main.bicep --parameters name="$NAME" subnetId="$SUBNET_ID" targetResourceId="$TARGET_RESOURCE_ID" groupId="$GROUP_ID" privateDnsZoneId="$PRIVATE_DNS_ZONE_ID"
az deployment group what-if --resource-group "$RG" --template-file 3_networking/private-endpoint/main.bicep --parameters name="$NAME" subnetId="$SUBNET_ID" targetResourceId="$TARGET_RESOURCE_ID" groupId="$GROUP_ID" privateDnsZoneId="$PRIVATE_DNS_ZONE_ID"
az deployment group create --resource-group "$RG" --template-file 3_networking/private-endpoint/main.bicep --parameters name="$NAME" subnetId="$SUBNET_ID" targetResourceId="$TARGET_RESOURCE_ID" groupId="$GROUP_ID" privateDnsZoneId="$PRIVATE_DNS_ZONE_ID"
```

For a reusable deployment, put your own values into an untracked
`*.local.bicepparam` file with a `using` declaration instead of embedding
environment identifiers into the module.

## Expected results and validation

The deployment returns the outputs declared at the end of `main.bicep`.
Inspect the deployment's provisioning state and resource IDs in Azure Portal
or Azure CLI. For a resource-group deployment:

```bash
az resource list --resource-group "$RG" --output table
```

For subscription resource-group creation, verify `az group show --name "$NAME"`.
Then perform the service-specific checks below. No live Azure deployment is
claimed by this repository's offline CI.

## Service-specific checks and limitations

Creating a private endpoint does not disable the service public endpoint or grant data-plane permission. Verify DNS and connection approval from a client in the linked VNet.

## Cleanup

Only if this is a dedicated disposable group, inspect its contents and delete it:

```bash
az resource list --resource-group "$RG" --output table
az group delete --name "$RG"
```

For the resource-group module use the created `NAME` as `RG`.
Do not delete shared prerequisites or groups containing unrelated work.
Deletion can be delayed by locks, soft-delete, protection settings, or backup
retention. Verify completion in Azure; stopping compute is not full cleanup.

## Cost and security considerations

Private endpoints and processed data are billable. Approval may require permissions on both the endpoint and target service.

Use least privilege and approved regions. Consult the current
[Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/)
and [Microsoft Bicep resource reference](https://learn.microsoft.com/azure/templates/).
