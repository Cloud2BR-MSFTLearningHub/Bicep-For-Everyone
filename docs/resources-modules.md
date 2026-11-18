# Resource declarations and reusable modules

## Resource anatomy

A declaration has a symbolic name, provider/type/API version, deployed name,
and provider-defined properties. Symbolic names connect resources in code;
deployed names must meet Azure naming rules. A child resource can use `parent`
instead of duplicating its full type/name expression.

```bicep title="Private DNS module"
--8<-- "3_networking/private-dns/main.bicep"
```

The VNet link depends on the zone through `parent`. An `existing` declaration,
as used by the subnet module, references rather than creates a resource.
It still needs a correct scope and name.

## Module composition

```bicep title="Private web architecture"
--8<-- "12_architecture-examples/secure-web/main.bicep"
```

A module is another Bicep file deployed with inputs. Passing `web.outputs.id`
to the endpoint establishes a dependency. Do not add a redundant `dependsOn`
when a resource/output reference already expresses it.

## Ownership and scope

Choose one owner for each resource. Do not mix inline subnet definitions and
separate subnet modules without understanding redeployment behavior.
Separate environment/resource-group boundaries from module boundaries.
Modules default to their parent's scope; cross-resource-group and subscription
deployments need an explicit scope supported by that module.

## RBAC is not networking

Managed identity creation does not grant access. A role assignment does not
create private DNS. A private endpoint does not authorize an application.
Model all three deliberately and test from the intended runtime.

**Exercise:** trace the secure-web dependency chain from VNet to subnet to
private endpoint. Explain why App Service creation can run alongside VNet
creation, but the endpoint cannot.
