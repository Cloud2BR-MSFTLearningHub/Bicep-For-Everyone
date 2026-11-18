@description('Globally unique Azure AI Services account and custom subdomain.')
param name string
@description('Supported Azure region; model availability differs by region.')
param location string = resourceGroup().location

resource account 'Microsoft.CognitiveServices/accounts@2024-10-01' = {
  name: name
  location: location
  kind: 'CognitiveServices'
  sku: { name: 'S0' }
  identity: { type: 'SystemAssigned' }
  properties: {
    customSubDomainName: name
    disableLocalAuth: true
    publicNetworkAccess: 'Disabled'
    networkAcls: { defaultAction: 'Deny' }
  }
}

output id string = account.id
