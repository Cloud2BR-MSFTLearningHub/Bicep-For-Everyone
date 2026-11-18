# Validate, preview, deploy, and clean up

## Four different checks

| Check | Azure login? | Creates workload resources? | What it establishes |
| --- | --- | --- | --- |
| Bicep build/lint | No, for these local modules | No | Syntax, types, configured analyzer rules |
| ARM validate | Yes | No workload creation | Server-side validation at its selected level |
| ARM what-if | Yes | No workload creation | Predicted changes, with provider/evaluation limitations |
| ARM create | Yes | Yes | An actual deployment attempt |

Validation and what-if require permissions and provider access. Neither is
proof that a later operation will succeed or that an application will work.

## Resource-group deployment

The module READMEs list the required parameters and dependencies. These Bash
commands illustrate the VNet example; set `RG` and `NAME` to your own lab values.

```bash
az account show --output table
az bicep build --file 0_core-infrastructure/virtual-network/main.bicep --stdout
az deployment group validate --resource-group "$RG" \
  --template-file 0_core-infrastructure/virtual-network/main.bicep --parameters name="$NAME"
az deployment group what-if --resource-group "$RG" \
  --template-file 0_core-infrastructure/virtual-network/main.bicep --parameters name="$NAME"
az deployment group create --resource-group "$RG" \
  --template-file 0_core-infrastructure/virtual-network/main.bicep --parameters name="$NAME"
az network vnet show --resource-group "$RG" --name "$NAME" --output table
```

Expected: the VNet address space is `10.20.0.0/16`, with no subnets yet.
Stop if what-if shows unexpected replacements, property resets, or scope.
The resource-group creation module instead uses `az deployment sub`.

## Inspect failures

```bash
az deployment group list --resource-group "$RG" --output table
az deployment operation group list --resource-group "$RG" \
  --name "$DEPLOYMENT_NAME" --output json
```

Read the innermost provider error, correlation ID, and failed resource.
Check permissions, policy, API/SKU/region compatibility, dependencies,
and quota before changing unrelated code.

## Cleanup is a separate operation

Inspect the group and delete it only if it is dedicated to the lab:

```bash
az resource list --resource-group "$RG" --output table
az group delete --name "$RG"
```

Protected backup data, locks, soft-delete, or purge protection can delay
cleanup. Verify the resulting state and cost view. See
[security and costs](security-costs.md) and [troubleshooting](troubleshooting.md).
