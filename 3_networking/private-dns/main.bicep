@description('Service private DNS zone, such as privatelink.vaultcore.azure.net.')
param name string
@description('Existing virtual network resource ID.')
param virtualNetworkId string

resource zone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: name
  location: 'global'
}
resource link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: zone
  name: 'client-network'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: { id: virtualNetworkId }
  }
}

output id string = zone.id
