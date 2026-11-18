@description('Globally unique Functions app name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing storage account name with identity-based host storage configured.')
param storageAccountName string
@description('Subnet delegated to Microsoft.Web/serverFarms, with storage private DNS connectivity.')
param integrationSubnetId string

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${name}-plan'
  location: location
  kind: 'elastic'
  sku: { name: 'EP1', tier: 'ElasticPremium' }
  properties: { reserved: true }
}
resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  kind: 'functionapp,linux'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    virtualNetworkSubnetId: integrationSubnetId
    publicNetworkAccess: 'Disabled'
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'Python|3.12'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      vnetRouteAllEnabled: true
      appSettings: [
        { name: 'FUNCTIONS_EXTENSION_VERSION', value: '~4' }
        { name: 'FUNCTIONS_WORKER_RUNTIME', value: 'python' }
        { name: 'AzureWebJobsStorage__accountName', value: storageAccountName }
        { name: 'AzureWebJobsStorage__credential', value: 'managedidentity' }
      ]
    }
  }
}

output id string = app.id
output principalId string = app.identity.principalId
