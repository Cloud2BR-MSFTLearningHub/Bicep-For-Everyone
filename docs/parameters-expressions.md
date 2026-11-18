# Parameters, variables, expressions, and functions

## Inputs and constraints

Parameters describe what callers may change. Use strings for names, booleans
for explicit choices, integers with bounds for capacity, and arrays/objects
for structured data. Prefer narrow types or allowed values where applicable.

```bicep title="Environment project"
--8<-- "13_projects/environment-foundation/main.bicep"
```

`@allowed` rejects misspelled environment values. `@minLength` and `@maxLength`
protect the naming prefix. These checks complement, rather than replace,
Azure resource-specific naming rules.

## Variables and expressions

`var` names a derived expression rather than another user input.
`uniqueString(resourceGroup().id, prefix, environment)` is deterministic, not
random and not a password. String interpolation combines readable names.
The ternary expression gives production longer log retention.
Array loops avoid copied resource blocks.

`resourceGroup()` and `subscription()` describe the current scope.
`resourceId()` and `subscriptionResourceId()` construct IDs; they do not
prove that a resource exists. `guid()` gives stable assignment names.
`empty()` supports optional configuration. Avoid hardcoded tenant,
subscription, and principal IDs.

## Parameter files

```bicep title="dev.bicepparam"
--8<-- "13_projects/environment-foundation/dev.bicepparam"
```

A `.bicepparam` file links to a template with `using`. Keep published samples
non-sensitive and environment-neutral; the sample region is a changeable lab
choice, not a guarantee of availability. Put real organization-specific values
into ignored `*.local.bicepparam` files.

## Secrets

For a module that genuinely needs a secret input, use `@secure()` and retrieve
the value through an approved Key Vault/deployment mechanism. Do not output
it, commit it, or use a secure decorator to justify an insecure default.
These modules avoid password inputs by using SSH public keys and identities.

**Exercise:** add a `test` parameter file, compile it with `az bicep build-params`,
and verify that `environment = 'testing'` fails the allowed-values check.
