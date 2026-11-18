# Getting started

**Goal:** compile a real Bicep file before creating any Azure resources.

## Install the tools

Install [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli),
[Visual Studio Code](https://code.visualstudio.com/), and the
[Bicep extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep).
The extension provides completions, diagnostics, hover descriptions, and a
visualizer; the CLI performs the automated compilation.

```shell
az version
az bicep install
az bicep version
```

Clone this repository or choose **Code > Download ZIP** on GitHub:

```shell
git clone https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone.git
cd Bicep-For-Everyone
az bicep build --file 0_core-infrastructure/resource-group/main.bicep --stdout
```

**Expected output:** ARM JSON with a subscription deployment schema, parameters,
a `Microsoft.Resources/resourceGroups` resource, and outputs. No Azure resource
has been created and no login is needed for this local compilation.

## Your first Bicep file

```bicep title="0_core-infrastructure/resource-group/main.bicep"
--8<-- "0_core-infrastructure/resource-group/main.bicep"
```

`targetScope` selects subscription deployment. `@description` becomes helpful
metadata. `param` accepts inputs, `resource` declares desired infrastructure,
and `output` returns non-secret information. The API version is the ARM contract
version, not a software version installed into the resource group.

## Optional Azure deployment

The following Bash commands require an Azure subscription and permission to
create resource groups. Use Azure Cloud Shell for the same shell syntax.
Substitute your own approved values for the variables.

```bash
az login
az account list --output table
az account set --subscription "$SUBSCRIPTION_ID"
az account show --output table
az deployment sub what-if --location "$LOCATION" \
  --template-file 0_core-infrastructure/resource-group/main.bicep \
  --parameters name="$RG" location="$LOCATION"
az deployment sub create --location "$LOCATION" \
  --template-file 0_core-infrastructure/resource-group/main.bicep \
  --parameters name="$RG" location="$LOCATION"
az group show --name "$RG" --output table
```

**Expected:** the named group exists in the chosen region. No paid workload
is in it yet. This does not grant permission to deploy arbitrary services.

## Cleanup and exercise

Confirm the group is dedicated to this lab before deletion:

```bash
az resource list --resource-group "$RG" --output table
az group delete --name "$RG"
```

**Try it:** add an `owner` tag through the `tags` parameter, compile again,
and locate that parameter reference in ARM JSON.
Continue with [fundamentals](fundamentals.md).
