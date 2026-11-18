# Troubleshooting

## Follow the failure layer

1. **Compiler:** read the first BCP error and source line. Fix type, symbol,
   resource property, or module-path errors before attempting deployment.
2. **Analyzer:** warnings may compile locally but fail this repository's CI.
   Fix the root cause; do not globally silence a rule.
3. **ARM validation:** confirm scope, principal permissions, policy,
   provider registration, dependency names, and API version.
4. **Provisioning:** inspect the deployment operation's innermost error.
5. **Connectivity/runtime:** verify DNS, network path, service approval,
   data-plane permissions, application configuration, and logs.

## Common symptoms

| Symptom | Likely check |
| --- | --- |
| `az bicep` missing | Install Azure CLI, then `az bicep install` |
| API type unavailable warning | Confirm resource/API in Microsoft reference and compiler version |
| Authorization failed | Check active tenant/subscription and scope-specific role |
| RBAC creation denied | Contributor is not role-assignment write permission |
| Name unavailable | Global service namespace or soft-deleted resource |
| SKU unavailable | Regional capacity, subscription restrictions, quota |
| Endpoint resolves publicly | Private DNS zone name/link, forwarding, client network |
| Private endpoint pending | Target-side approval and permissions |
| Identity exists but access fails | Data role, principal/object ID, propagation, token audience |
| Function host fails | Storage RBAC, blob/queue/table connectivity, package delivery |
| AKS API unreachable | Private cluster requires a network-connected client |
| No telemetry | Resource creation does not instrument the app or generate data |
| Vault will not delete | Protected items, soft-delete, locks, retention |

## Website problems

Run the strict MkDocs build and the generated-link checker. Shared snippets
must point to real files. Run the catalog generator after changing module
parameters or catalog notes, then use `--check` to verify synchronization.
If the live site is old, inspect Actions before forcing a browser refresh.

## Report safely

Share the compiler version, sanitized error code, reproduction steps, and
example path. Remove tokens, private keys, data, and organization identifiers.
Use the [issue forms](https://github.com/Cloud2BR-MSFTLearningHub/Bicep-For-Everyone/issues/new/choose).
