@description('Globally unique SQL server name.')
param name string
@description('Database name.')
param databaseName string = 'learning'
@description('Azure region.')
param location string = resourceGroup().location
@description('Microsoft Entra administrator display name.')
param administratorLogin string
@description('Microsoft Entra administrator object ID (not an application/client ID).')
param administratorObjectId string

resource server 'Microsoft.Sql/servers@2023-08-01' = {
  name: name
  location: location
  properties: {
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
    administrators: {
      administratorType: 'ActiveDirectory'
      principalType: 'Group'
      login: administratorLogin
      sid: administratorObjectId
      tenantId: tenant().tenantId
      azureADOnlyAuthentication: true
    }
  }
}
resource database 'Microsoft.Sql/servers/databases@2023-08-01' = {
  parent: server
  name: databaseName
  location: location
  sku: { name: 'Basic', tier: 'Basic' }
}

output id string = server.id
output databaseId string = database.id
