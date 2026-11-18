@description('Globally unique Cosmos DB account name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: name
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [{ locationName: location, failoverPriority: 0 }]
    consistencyPolicy: { defaultConsistencyLevel: 'Session' }
    capabilities: [{ name: 'EnableServerless' }]
    publicNetworkAccess: 'Disabled'
    disableLocalAuth: true
    minimalTlsVersion: 'Tls12'
  }
}

output id string = account.id
output endpoint string = account.properties.documentEndpoint
