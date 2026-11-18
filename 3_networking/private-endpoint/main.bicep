@description('Private endpoint name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing subnet for the endpoint network interface.')
param subnetId string
@description('Existing target resource ID.')
param targetResourceId string
@description('Target subresource, such as blob, vault, sites, or sqlServer.')
param groupId string
@description('Existing private DNS zone ID, already linked to the client VNet.')
param privateDnsZoneId string

resource endpoint 'Microsoft.Network/privateEndpoints@2024-05-01' = {
  name: name
  location: location
  properties: {
    subnet: { id: subnetId }
    privateLinkServiceConnections: [{
      name: '${name}-connection'
      properties: { privateLinkServiceId: targetResourceId, groupIds: [groupId] }
    }]
  }
}
resource dns 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-05-01' = {
  parent: endpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [{ name: 'service', properties: { privateDnsZoneId: privateDnsZoneId } }]
  }
}

output id string = endpoint.id
