@description('Globally unique PostgreSQL flexible server name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing subnet delegated to Microsoft.DBforPostgreSQL/flexibleServers.')
param delegatedSubnetId string
@description('Existing linked private DNS zone ending in postgres.database.azure.com.')
param privateDnsZoneId string
@description('Microsoft Entra administrator group object ID.')
param administratorObjectId string
@description('Microsoft Entra administrator group display name.')
param administratorName string

resource server 'Microsoft.DBforPostgreSQL/flexibleServers@2024-08-01' = {
  name: name
  location: location
  sku: { name: 'Standard_B1ms', tier: 'Burstable' }
  properties: {
    version: '16'
    createMode: 'Default'
    authConfig: {
      activeDirectoryAuth: 'Enabled'
      passwordAuth: 'Disabled'
      tenantId: tenant().tenantId
    }
    storage: { storageSizeGB: 32 }
    backup: { backupRetentionDays: 7, geoRedundantBackup: 'Disabled' }
    network: {
      delegatedSubnetResourceId: delegatedSubnetId
      privateDnsZoneArmResourceId: privateDnsZoneId
      publicNetworkAccess: 'Disabled'
    }
  }
}
resource admin 'Microsoft.DBforPostgreSQL/flexibleServers/administrators@2024-08-01' = {
  parent: server
  name: administratorObjectId
  properties: {
    principalName: administratorName
    principalType: 'Group'
    tenantId: tenant().tenantId
  }
}

output id string = server.id
