@description('Globally unique vault name, 3-24 characters.')
@minLength(3)
@maxLength(24)
param name string
@description('Azure region.')
param location string = resourceGroup().location

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: name
  location: location
  properties: {
    tenantId: tenant().tenantId
    sku: { family: 'A', name: 'standard' }
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 7
    publicNetworkAccess: 'Disabled'
    networkAcls: { defaultAction: 'Deny', bypass: 'None' }
  }
}

output id string = vault.id
output uri string = vault.properties.vaultUri
