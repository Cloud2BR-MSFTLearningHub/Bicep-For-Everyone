"""Synchronize module READMEs and site source views from the documented catalog."""
import argparse
import re
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
REPO = "https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/blob/main"
MODULES = [
    ("0_core-infrastructure/resource-group", "Resource group", "Beginner",
     "Create a subscription-scoped resource group for an isolated learning environment.",
     "Subscription deployment permissions and an allowed Azure region.",
     "A resource group has no direct charge, but everything deployed inside it may. Deleting the group deletes its contained resources.",
     "The deployment location stores subscription deployment metadata; the resource-group location is supplied independently."),
    ("0_core-infrastructure/virtual-network", "Virtual network", "Beginner",
     "Define the private address space that later subnet and workload modules use.",
     "Plan non-overlapping address ranges with your network team.",
     "The VNet itself has no direct hourly charge; gateways, peering traffic, endpoints, and appliances may.",
     "This module owns address space, not subnets. Keep subnet ownership in the subnet module and review what-if before redeploying existing networks."),
    ("0_core-infrastructure/subnet", "Subnet", "Beginner",
     "Add an explicitly sized subnet to an existing virtual network, optionally attaching an NSG and service delegation.",
     "The parent VNet must exist in the deployment resource group; an optional NSG must already exist.",
     "A subnet alone has no direct charge. NSGs and routes must be reviewed before workload attachment.",
     "Address ranges must fit the VNet and not overlap. Serialize separate subnet updates to the same VNet; the multi-tier lab uses batchSize(1)."),
    ("0_core-infrastructure/network-security-group", "Network security group", "Beginner",
     "Create an NSG with deny-all inbound as the default policy, replacing the default VNet inbound allow behavior.",
     "Decide exactly which source prefixes and destination ports a workload requires.",
     "The NSG has no direct charge. This default intentionally blocks all incoming connections, including same-VNet connections.",
     "Creating an NSG does not attach it. Apply its ID to a subnet or NIC. Outbound traffic still follows Azure default NSG rules."),
    ("0_core-infrastructure/public-ip", "Public IP", "Beginner",
     "Reserve a Standard static IPv4 public address without exposing an attached workload.",
     "Confirm regional public IPv4 quota and a justified need for public addressing.",
     "Standard public IPs can incur charges while unassociated. Delete unused allocations.",
     "The address is not attached to any NIC or load balancer. Inbound reachability also needs explicit NSG and application rules."),
    ("0_core-infrastructure/route-table", "Route table", "Beginner",
     "Create a route table with explicit user-defined routes.",
     "Know the intended next-hop type and any appliance private IP before adding routes.",
     "The table has no direct charge; the next-hop firewall, gateway, and traffic can be billable.",
     "An empty route list does not change traffic. Attach the table to a subnet and validate effective routes; do not blackhole production traffic."),
    ("1_storage-databases/storage-account", "Storage account, blobs, files, lifecycle", "Intermediate",
     "Create private-only StorageV2 with optional private containers, SMB file shares, and a cool-tier lifecycle policy.",
     "Choose a globally unique lowercase alphanumeric name. For data access, provision private endpoints, private DNS, and appropriate identity roles.",
     "Capacity, transactions, cool-tier minimum retention, data retrieval, and private endpoints may be charged. Public blob access and shared keys are disabled.",
     "SMB shares are provisioned but SMB identity integration is not configured. Configure an approved Azure Files identity source and ACLs before mounting. Blob and file endpoints require separate private endpoints."),
    ("1_storage-databases/azure-sql", "Azure SQL", "Intermediate",
     "Create an Entra-only SQL logical server and a Basic database without a SQL password.",
     "Supply a real Microsoft Entra administrator group name/object ID and configure private endpoint DNS for database connectivity.",
     "The database is billable while idle. Public network access is disabled and no broad firewall exception is created.",
     "Entra authentication still requires database users/permissions. The administrator principal must be a group because this example sets principalType to Group."),
    ("1_storage-databases/cosmos-db", "Cosmos DB", "Intermediate",
     "Create a serverless NoSQL account with session consistency, private networking, and local key authentication disabled.",
     "Use a region supporting serverless and configure Cosmos DB data-plane RBAC and private DNS separately.",
     "Requests, stored data, and networking incur charges. Serverless is not a guarantee of zero cost.",
     "This creates the account, not a database/container, partition key, or data role assignment. Plan partitioning before application ingestion."),
    ("1_storage-databases/postgresql", "PostgreSQL Flexible Server", "Advanced",
     "Deploy PostgreSQL 16 into delegated private networking with Entra group administration and password authentication disabled.",
     "Provide an unused subnet delegated to Microsoft.DBforPostgreSQL/flexibleServers, a correctly linked private DNS zone, and an Entra group.",
     "Compute, storage, backups, and networking are charged. Burstable single-server sizing is for learning, not an HA production topology.",
     "DNS must already be linked to the delegated VNet. Check regional SKU/version support and configure application database roles after deployment."),
    ("2_compute-containers/virtual-machine", "Linux virtual machine", "Intermediate",
     "Create a Trusted Launch Ubuntu VM and private NIC with SSH-key authentication and a system-assigned identity.",
     "Provide a subnet, supported VM quota, and an SSH public key. Configure an NSG plus a private management path such as VPN or Bastion.",
     "Running compute and disks are billable. Deallocation stops compute billing but not disk costs; deleting the dedicated group removes lab resources.",
     "No public IP, Bastion, NAT, or application is deployed. Private-only VMs need explicit outbound access for package installation. The image uses latest; pin an image version for production reproducibility."),
    ("2_compute-containers/virtual-machine-scale-set", "Virtual machine scale set", "Advanced",
     "Create a uniform private Ubuntu scale set with a configurable instance count and manual image upgrades.",
     "Provide subnet connectivity, an SSH public key, and Standard_D2s_v5 quota.",
     "Every instance and managed disk can be charged. A count of zero does not eliminate all possible supporting costs.",
     "No load balancer, health probe, autoscale rule, or outbound NAT is created. Add those deliberately before hosting an application."),
    ("2_compute-containers/app-service", "App Service", "Intermediate",
     "Create a Linux Basic plan and Node.js web-app hosting resource with HTTPS, managed identity, and basic publishing credentials disabled.",
     "Choose a globally unique site name and ensure Linux App Service capacity in the selected region.",
     "The B1 plan is charged even when the site is stopped. Public access defaults to disabled; use the secure-web lab for inbound private connectivity.",
     "No application code, user authentication, or outbound VNet integration is included. enablePublicAccess is an explicit lab opt-in, not an authentication control."),
    ("2_compute-containers/azure-functions", "Azure Functions", "Advanced",
     "Create a private Linux Python Functions host on Elastic Premium with identity-based host storage settings.",
     "Provide a delegated Microsoft.Web/serverFarms integration subnet and existing private storage with blob/queue/table connectivity. Assign the returned identity the documented host-storage roles before starting code.",
     "EP1 has standing charges. Private endpoints, storage, and network traffic add costs. No storage keys are embedded.",
     "This is hosting infrastructure, not a running function. Complete host-storage RBAC, private endpoints/DNS, deployment package or container delivery, inbound private access, and any trigger-specific settings. Review official identity-based connection requirements."),
    ("2_compute-containers/container-apps", "Container Apps", "Intermediate",
     "Create an internal-ingress container app in an existing managed environment with scale-to-zero configuration.",
     "Provide an existing Container Apps environment, a publicly pullable image, and its actual listening port.",
     "Environment networking, logging, and running replicas can cost money even with minReplicas set to zero.",
     "Ingress is internal to the environment. Private registry authentication, custom domains, environment creation, and application-specific health probes are separate design work."),
    ("2_compute-containers/aks", "Azure Kubernetes Service", "Advanced",
     "Create a private AKS API server with Entra/Azure RBAC, local accounts disabled, OIDC, and workload identity.",
     "Provide administrator group object IDs, sufficient VM quota, and a private network path to administer the API.",
     "Free cluster management tier does not mean free worker nodes, disks, load balancer, or traffic.",
     "A single system node is a learning topology, not HA. Azure RBAC permissions and workload identity federation still require assignments. The cluster uses managed outbound load balancing."),
    ("3_networking/private-endpoint", "Private endpoint", "Intermediate",
     "Create a private endpoint and DNS zone group for one existing service subresource.",
     "Provide the correct target ID, service group ID, subnet, and service-specific private DNS zone linked to the client VNet.",
     "Private endpoints and processed data are billable. Approval may require permissions on both the endpoint and target service.",
     "Creating a private endpoint does not disable the service public endpoint or grant data-plane permission. Verify DNS and connection approval from a client in the linked VNet."),
    ("3_networking/private-dns", "Private DNS", "Intermediate",
     "Create a service-specific private DNS zone and link it to an existing VNet without VM autoregistration.",
     "Supply the service's exact recommended private DNS zone and a real VNet resource ID.",
     "Hosted zones and DNS queries can incur charges.",
     "Use the private-endpoint module to populate service records. A VNet link alone does not provide on-premises DNS forwarding."),
    ("4_identity-security/key-vault", "Key Vault", "Intermediate",
     "Create an RBAC-enabled, private-only vault with soft delete and purge protection.",
     "Choose a globally unique vault name and plan private endpoint/DNS and data-plane roles.",
     "Operations and private networking are charged. Purge protection prevents immediate permanent deletion during retention.",
     "The deployer receives no automatic secret access. Deleted names remain reserved during soft-delete retention; do not expect immediate reuse."),
    ("4_identity-security/managed-identity", "Managed identity", "Beginner",
     "Create a reusable user-assigned managed identity without credentials.",
     "Permission to create managed identities; consumers need permission to assign this identity.",
     "An identity has no direct charge. Roles attached to it can grant significant access.",
     "clientId identifies an application identity; principalId is the Entra object ID used by role assignments. Creating an identity alone grants no Azure permissions."),
    ("4_identity-security/role-assignment", "Role assignment and RBAC", "Intermediate",
     "Assign a selected existing Azure role to a principal at the current resource-group scope using a deterministic GUID.",
     "Use a real principal object ID and role definition GUID. You need role-assignment write permission, not only Contributor.",
     "RBAC has no direct charge, but an overly broad role is a security risk. Prefer a narrower resource-scoped variant when appropriate.",
     "This intentionally demonstrates resource-group scope. It does not create custom roles or Cosmos/SQL data-plane roles. Allow for Entra propagation after identity creation."),
    ("5_analytics-bigdata/event-hubs", "Event Hubs analytics ingestion", "Intermediate",
     "Create a private Standard Event Hubs namespace and a two-partition ingestion hub.",
     "Choose a unique namespace, private endpoint/DNS, and Entra data sender/receiver roles.",
     "Throughput units, ingress, retention, and private networking can be charged even before downstream analytics is added.",
     "This is an ingestion foundation, not a complete analytics pipeline. Producers, consumers, schema design, and capture/storage are not provisioned."),
    ("6_monitoring-management/log-analytics", "Log Analytics", "Beginner",
     "Create a workspace with configurable retention and local authentication disabled.",
     "Select an allowed workspace region and decide what data is appropriate to collect.",
     "Ingestion, retention beyond included allowances, and query features can be charged. Avoid collecting sensitive payloads.",
     "A workspace alone collects no workload logs. Add diagnostic settings or data collection rules, then confirm actual ingestion."),
    ("6_monitoring-management/application-insights", "Application Insights", "Intermediate",
     "Create a workspace-based telemetry component with local authentication disabled.",
     "Provide an existing Log Analytics workspace and choose an SDK supporting Entra-authenticated telemetry.",
     "Telemetry ingestion and retention are charged through the workspace. Review sampling and personal-data collection.",
     "The resource does not instrument an application. Configure its SDK, connection metadata, managed identity, and Monitoring Metrics Publisher role as documented."),
    ("6_monitoring-management/diagnostic-settings", "Key Vault diagnostic settings", "Intermediate",
     "Route an existing Key Vault's AuditEvent logs and AllMetrics to an existing workspace.",
     "The Key Vault and workspace must exist; you need permission to attach diagnostics and access the destination.",
     "Log ingestion and retention can cost money. Audit data may contain sensitive operational metadata.",
     "Diagnostic categories vary by resource type. This is intentionally a typed Key Vault example, not a misleading universal category list."),
    ("6_monitoring-management/metric-alert", "Azure Monitor CPU alert", "Intermediate",
     "Create an Azure Monitor five-minute average CPU alert for an existing VM with an existing action group.",
     "Provide the VM ID and an action group whose notification receivers have been tested.",
     "Metric alert rules and notifications may incur charges.",
     "Deployment does not prove delivery. Trigger a controlled CPU test, review alert history, and verify receiver notifications."),
    ("8_ai-ml/ai-services", "Azure AI Services", "Intermediate",
     "Create a multi-service AI account with managed identity, private networking, and key authentication disabled.",
     "Confirm service availability, subscription eligibility, private DNS, and the required Entra data roles.",
     "API usage is billable; model capacity and pricing vary. Never upload restricted data without authorization.",
     "No model deployment, inference quota, or training workspace is created. Choose an approved model/service, region, and data-governance design before usage."),
    ("9_migration-backup/recovery-vault", "Recovery Services vault", "Intermediate",
     "Create a private-network Recovery Services vault with soft-delete settings for a future backup design.",
     "Review supported workloads, private connectivity requirements, and backup operator permissions.",
     "Protected instances, retained backup data, and restores may be charged. Vault deletion can be blocked by protected or soft-deleted items.",
     "A vault is not a backup. Add a workload-specific policy and protection registration, perform a backup, and test a restore. This module does not migrate workloads."),
    ("11_integration-services/service-bus", "Service Bus", "Intermediate",
     "Create a private Premium namespace and a queue with duplicate detection and dead-lettering.",
     "Choose a unique namespace, private endpoint/DNS, and appropriate Entra data sender/receiver roles.",
     "Premium messaging units have substantial standing charges; use a short-lived sandbox and estimate the cost first.",
     "Premium is chosen for private endpoint support. No message producer/consumer is deployed; test retries, dead-letter handling, and idempotency in application code."),
    ("12_architecture-examples/hub-and-spoke", "Hub-and-spoke networking", "Advanced",
     "Compose two VNet modules with non-overlapping address spaces and bidirectional peerings.",
     "Check address overlap and peering permissions. Choose a prefix unique in the learning group.",
     "Peering data transfer can be charged. No firewall, VPN gateway, or public endpoint is created.",
     "Peering is not transitive and this lab does not centralize egress. Add a hub appliance, routing, DNS, and gateway transit only after designing them."),
    ("12_architecture-examples/secure-web", "Private web hosting", "Advanced",
     "Compose a private App Service, VNet, subnet, private DNS zone/link, and inbound private endpoint.",
     "Choose a globally unique site name and provide a client path into the new VNet for testing.",
     "The App Service plan, private endpoint, and DNS zone are billable. Public web access stays disabled.",
     "Expected result is private hosting infrastructure, not an application. Deploy code from a network-connected runner. Private ingress does not configure outbound VNet integration or user authentication."),
    ("12_architecture-examples/multi-tier", "Multi-tier network segmentation", "Advanced",
     "Compose web, application, and data subnets with individual NSGs and explicit tier-to-tier TCP paths.",
     "Plan the 10.40.0.0/16 range and understand the sample ports: 443, 8443, and 5432.",
     "The VNet/NSG foundation has no direct compute charge. No application, database, load balancer, or public access is deployed.",
     "This is a network pattern, not a complete running three-tier application. Replace sample ports/prefixes with your design and validate effective NSG rules."),
    ("13_projects/environment-foundation", "Environment-based infrastructure project", "Advanced",
     "Compose network, private storage, logging, and identity modules with deterministic names and dev/test/prod parameters.",
     "Use a dedicated resource group per environment. Review dev.bicepparam or prod.bicepparam and region policy before deployment.",
     "Storage/logging usage and retention are billable. prod changes retention only; it is not a production-readiness guarantee.",
     "This complete infrastructure exercise intentionally includes no application, data access, or role grants. The storage endpoint is private-only; add DNS/endpoints and roles before data tests."),
]


def build_files():
    files = {}
    catalog = ["# Bicep module catalog\n\n",
               "Choose by service and complexity. Every source view below includes the canonical README and Bicep file at build time.\n\n",
               "| Example | Level | Category |\n| --- | --- | --- |\n"]
    for path, title, level, purpose, prerequisites, costs, notes in MODULES:
        source = ROOT / path / "main.bicep"
        text = source.read_text(encoding="utf-8")
        parameters = re.findall(r"^param (\w+) (\w+)(.*)$", text, re.MULTILINE)
        required = [(name, kind) for name, kind, default in parameters if not default.strip()]
        arguments = " ".join(f'{name}="${re.sub(r"(?<!^)(?=[A-Z])", "_", name).upper()}"' for name, _ in required)
        scope = "sub" if "targetScope = 'subscription'" in text else "group"
        scope_args = '--location "$LOCATION"' if scope == "sub" else '--resource-group "$RG"'
        slug = path.replace("/", "--")
        catalog.append(f"| [{title}](modules/{slug}.md) | {level} | `{path.split('/')[0]}` |\n")
        table = "| Parameter | Type | Requirement |\n| --- | --- | --- |\n"
        for name, kind, default in parameters:
            requirement = "Required" if not default.strip() else "Optional; see source default"
            table += f"| `{name}` | `{kind}` | {requirement} |\n"
        params_note = "Set shell variables " + ", ".join(
            f"`{re.sub(r'(?<!^)(?=[A-Z])', '_', name).upper()}`" for name, _ in required
        ) + " to your own approved values." if required else "No required module inputs."
        readme = f"""# {title}

**Level:** {level}

## Overview and purpose

{purpose}

## Azure services and dependencies

Read [main.bicep]({REPO}/{path}/main.bicep) for the exact resource types,
supported API versions, decorators, and outputs. No secret values are required
or emitted by this module.

## Prerequisites

Install Azure CLI and Bicep, authenticate to the intended subscription, and
confirm `az account show` before executing cloud commands.
{prerequisites}

Use the repository root as the working directory. Commands below use Bash
(Azure Cloud Shell works); PowerShell variable syntax differs.
Set `RG` to a dedicated existing sandbox group (except for the subscription-scoped
resource-group example), and `LOCATION` to an approved Azure region.
{params_note}
For array/object inputs, put valid JSON in the corresponding quoted variable.
Never use example IDs as real principal/resource IDs.

## Important parameters

{table}
Descriptions and defaults live beside each declaration in the canonical source.
Names must meet the individual Azure service's naming rules.

## Bicep source and usage

[View the complete source]({REPO}/{path}/main.bicep).
Reference this module from another Bicep file with a relative module path and
a `params` object. The resources/modules lesson shows composition and dependencies.

## Compile and validate locally

```bash
az bicep build --file {path}/main.bicep --stdout
```

Compilation and linting need no Azure login and create no resources. A successful
compile is not evidence that a deployment or application has been tested.

## Deployment instructions

These are opt-in cloud operations, never routine CI steps. Review policy,
permissions, region, quotas, dependencies, and price before proceeding.

```bash
az deployment {scope} validate {scope_args} --template-file {path}/main.bicep --parameters {arguments}
az deployment {scope} what-if {scope_args} --template-file {path}/main.bicep --parameters {arguments}
az deployment {scope} create {scope_args} --template-file {path}/main.bicep --parameters {arguments}
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

{notes}

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

{costs}

Use least privilege and approved regions. Consult the current
[Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/)
and [Microsoft Bicep resource reference](https://learn.microsoft.com/azure/templates/).
"""
        files[Path(path) / "README.md"] = readme
        files[Path("docs/modules") / (slug + ".md")] = (
            f'--8<-- "{path}/README.md"\n\n'
            f'## Complete Bicep source\n\n```bicep title="{path}/main.bicep"\n'
            f'--8<-- "{path}/main.bicep"\n```\n'
        )
    files[Path("docs/catalog.md")] = "".join(catalog)
    return files


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    files = build_files()
    sources = {path.parent.relative_to(ROOT).as_posix() for path in ROOT.glob("[0-9]*/*/main.bicep")}
    documented = {row[0] for row in MODULES}
    if sources != documented:
        raise SystemExit(f"Catalog coverage differs: {sources ^ documented}")
    stale = []
    for relative, content in files.items():
        target = ROOT / relative
        if args.check:
            if not target.is_file() or target.read_text(encoding="utf-8") != content:
                stale.append(str(relative))
        else:
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_text(content, encoding="utf-8")
    if stale:
        raise SystemExit("Regenerate catalog/READMEs: " + ", ".join(stale))
    print(f"Synchronized {len(MODULES)} documented Bicep modules and their website source views.")
