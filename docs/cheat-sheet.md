# Bicep cheat sheet

These are command patterns, not permission to deploy.

| Task | Command or syntax |
| --- | --- |
| Install/update CLI | `az bicep install` / `az bicep upgrade` |
| Record compiler | `az bicep version` |
| Compile without deployment | `az bicep build --file main.bicep --stdout` |
| Compile parameters | `az bicep build-params --file dev.bicepparam --stdout` |
| Format source | `az bicep format --file main.bicep` |
| Confirm scope | `az account show --output table` |
| Group preview | `az deployment group what-if --resource-group "$RG" --template-file main.bicep` |
| Subscription preview | `az deployment sub what-if --location "$LOCATION" --template-file main.bicep` |
| Existing reference | `resource name 'Provider/type@version' existing = { ... }` |
| Child ownership | `parent: symbolicParent` |
| Module input | `params: { name: value }` |
| Module output | `symbolicModule.outputs.id` |
| Interpolation | `'${prefix}-${environment}'` |
| Conditional resource | `resource x 'Provider/type@version' = if (enabled) { ... }` |
| Loop | `[for item in items: { ... }]` |
| Secret input decorator | `@secure()` (never a substitute for secure value handling) |

Supply the module's required parameters to deployment commands. Keep local
values in ignored parameter files and always inspect what-if before create.
Use [the catalog](catalog.md) for complete compilable files rather than
treating syntax fragments as deployable templates.
