@description('Globally unique Service Bus namespace name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Queue name.')
param queueName string = 'work'

resource namespace 'Microsoft.ServiceBus/namespaces@2024-01-01' = {
  name: name
  location: location
  sku: { name: 'Premium', tier: 'Premium', capacity: 1 }
  properties: {
    disableLocalAuth: true
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
}
resource queue 'Microsoft.ServiceBus/namespaces/queues@2024-01-01' = {
  parent: namespace
  name: queueName
  properties: { requiresDuplicateDetection: true, deadLetteringOnMessageExpiration: true }
}

output id string = namespace.id
output queueId string = queue.id
