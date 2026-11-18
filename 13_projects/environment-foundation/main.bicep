@description('Organization or workload naming prefix.')
@minLength(2)
@maxLength(12)
param prefix string
@description('Deployment environment.')
@allowed(['dev', 'test', 'prod'])
param environment string
@description('Azure region.')
param location string = resourceGroup().location

var suffix = uniqueString(resourceGroup().id, prefix, environment)
var tags = { environment: environment, managedBy: 'bicep' }
module network '../../0_core-infrastructure/virtual-network/main.bicep' = {
  name: 'network'
  params: { name: '${prefix}-${environment}-vnet', location: location, tags: tags }
}
module storage '../../1_storage-databases/storage-account/main.bicep' = {
  name: 'storage'
  params: { name: 'st${suffix}', location: location, containers: ['documents'], coolAfterDays: 30 }
}
module monitoring '../../6_monitoring-management/log-analytics/main.bicep' = {
  name: 'monitoring'
  params: { name: '${prefix}-${environment}-logs', location: location, retentionDays: environment == 'prod' ? 90 : 30 }
}
module identity '../../4_identity-security/managed-identity/main.bicep' = {
  name: 'identity'
  params: { name: '${prefix}-${environment}-identity', location: location }
}

output networkId string = network.outputs.id
output storageId string = storage.outputs.id
output workspaceId string = monitoring.outputs.id
output principalId string = identity.outputs.principalId
