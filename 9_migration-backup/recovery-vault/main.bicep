@description('Recovery Services vault name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location

resource vault 'Microsoft.RecoveryServices/vaults@2024-04-01' = {
  name: name
  location: location
  sku: { name: 'Standard' }
  identity: { type: 'SystemAssigned' }
  properties: {
    publicNetworkAccess: 'Disabled'
    securitySettings: {
      softDeleteSettings: { softDeleteState: 'Enabled', softDeleteRetentionPeriodInDays: 14 }
    }
  }
}

output id string = vault.id
