@description('Application Insights component name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing Log Analytics workspace resource ID.')
param workspaceId string

resource component 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: workspaceId
    DisableLocalAuth: true
  }
}

output id string = component.id
