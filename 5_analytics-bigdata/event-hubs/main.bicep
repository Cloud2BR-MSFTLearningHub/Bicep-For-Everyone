@description('Globally unique Event Hubs namespace name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Event hub name.')
param hubName string = 'events'

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' = {
  name: name
  location: location
  sku: { name: 'Standard', tier: 'Standard', capacity: 1 }
  properties: { disableLocalAuth: true, minimumTlsVersion: '1.2', publicNetworkAccess: 'Disabled' }
}
resource hub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  parent: namespace
  name: hubName
  properties: {
    partitionCount: 2
    retentionDescription: { cleanupPolicy: 'Delete', retentionTimeInHours: 24 }
  }
}

output id string = namespace.id
output hubId string = hub.id
