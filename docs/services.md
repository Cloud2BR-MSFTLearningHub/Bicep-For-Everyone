# Choose an Azure service example

Use the [module catalog](catalog.md) for all complete README/source views.

| Area | Start with | What else you must design |
| --- | --- | --- |
| Core/network | VNet, subnet, NSG, routes, public IP | Address planning, rule attachment, egress, operations |
| Compute | VM, VMSS | Private management, application setup, health and upgrades |
| Web/serverless | App Service, Functions, Container Apps | Code delivery, identity, runtime configuration, networking |
| Containers | AKS | Workload roles, availability, scaling, cluster operations |
| Storage | StorageV2, blobs, files, lifecycle | Data roles, endpoints, SMB identity, retention |
| Databases | SQL, Cosmos DB, PostgreSQL | Data schema, database users/roles, backup/restore and HA |
| Security | Key Vault, managed identity, RBAC | Least privilege, private DNS, auditing |
| Monitoring | Workspace, Insights, diagnostics, alert | Instrumentation, data collection, tested notifications |
| Analytics | Event Hubs ingestion | Producers, consumers, downstream analysis and governance |
| AI/ML | AI Services account | Model/API selection, quotas, responsible AI, data access |
| Integration | Service Bus queue | Retry, ordering, dead-letter handling, idempotency |
| Migration/backup | Recovery Services vault | Workload discovery, policies, protection, restore testing |

The catalog deliberately distinguishes a service foundation from a complete
application. Do not claim that a vault is a tested backup or an AI account
is a deployed model. IoT and media-service directories from the Terraform
reference are not copied as empty placeholders.
