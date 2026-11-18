@description('Container app name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing managed Container Apps environment resource ID.')
param environmentId string
@description('Publicly pullable OCI image including its version tag or digest.')
param image string
@description('Container listening port.')
param targetPort int = 80

resource app 'Microsoft.App/containerApps@2024-03-01' = {
  name: name
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    environmentId: environmentId
    configuration: {
      ingress: { external: false, targetPort: targetPort, allowInsecure: false }
    }
    template: {
      containers: [{
        name: 'application'
        image: image
        resources: { cpu: json('0.25'), memory: '0.5Gi' }
      }]
      scale: { minReplicas: 0, maxReplicas: 2 }
    }
  }
}

output id string = app.id
