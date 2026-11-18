@description('Globally unique web app name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Public ingress; disabled unless explicitly enabled for a learning lab.')
param enablePublicAccess bool = false

resource plan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${name}-plan'
  location: location
  kind: 'linux'
  sku: { name: 'B1', tier: 'Basic' }
  properties: { reserved: true }
}
resource app 'Microsoft.Web/sites@2023-12-01' = {
  name: name
  location: location
  kind: 'app,linux'
  identity: { type: 'SystemAssigned' }
  properties: {
    serverFarmId: plan.id
    httpsOnly: true
    publicNetworkAccess: enablePublicAccess ? 'Enabled' : 'Disabled'
    siteConfig: {
      linuxFxVersion: 'NODE|22-lts'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      alwaysOn: true
    }
  }
}
resource ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: app
  name: 'ftp'
  properties: { allow: false }
}
resource scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  parent: app
  name: 'scm'
  properties: { allow: false }
}

output id string = app.id
output principalId string = app.identity.principalId
output hostname string = app.properties.defaultHostName
