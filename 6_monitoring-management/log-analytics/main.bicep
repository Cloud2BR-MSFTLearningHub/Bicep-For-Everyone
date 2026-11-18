@description('Log Analytics workspace name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Log retention days.')
@minValue(30)
@maxValue(730)
param retentionDays int = 30

resource workspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: name
  location: location
  properties: {
    sku: { name: 'PerGB2018' }
    retentionInDays: retentionDays
    features: { enableLogAccessUsingOnlyResourcePermissions: true, disableLocalAuth: true }
  }
}

output id string = workspace.id
