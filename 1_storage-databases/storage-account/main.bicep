@description('Globally unique lowercase alphanumeric storage name.')
@minLength(3)
@maxLength(24)
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Private blob containers to create.')
param containers array = []
@description('SMB file shares to create. Shared key access remains disabled.')
param fileShares array = []
@description('Days before base blobs move to cool tier; zero disables the lifecycle policy.')
@minValue(0)
param coolAfterDays int = 0

resource account 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: name
  location: location
  kind: 'StorageV2'
  sku: { name: 'Standard_LRS' }
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
    allowSharedKeyAccess: false
    publicNetworkAccess: 'Disabled'
    defaultToOAuthAuthentication: true
  }
}
resource blobs 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {
    deleteRetentionPolicy: { enabled: true, days: 7 }
  }
}
resource blobContainers 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = [for container in containers: {
  parent: blobs
  name: container
  properties: { publicAccess: 'None' }
}]
resource files 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: account
  name: 'default'
  properties: {}
}
resource shares 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = [for share in fileShares: {
  parent: files
  name: share
  properties: { shareQuota: 100, enabledProtocols: 'SMB' }
}]
resource lifecycle 'Microsoft.Storage/storageAccounts/managementPolicies@2023-05-01' = if (coolAfterDays > 0) {
  parent: account
  name: 'default'
  properties: {
    policy: {
      rules: [
        {
          name: 'CoolBaseBlobs'
          enabled: true
          type: 'Lifecycle'
          definition: {
            filters: { blobTypes: ['blockBlob'] }
            actions: {
              baseBlob: { tierToCool: { daysAfterModificationGreaterThan: coolAfterDays } }
            }
          }
        }
      ]
    }
  }
}

output id string = account.id
output name string = account.name
