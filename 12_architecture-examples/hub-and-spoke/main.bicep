@description('Short naming prefix.')
@maxLength(20)
param prefix string
@description('Azure region.')
param location string = resourceGroup().location

module hub '../../0_core-infrastructure/virtual-network/main.bicep' = {
  name: 'hub'
  params: { name: '${prefix}-hub', location: location, addressPrefixes: ['10.0.0.0/16'] }
}
module spoke '../../0_core-infrastructure/virtual-network/main.bicep' = {
  name: 'spoke'
  params: { name: '${prefix}-spoke', location: location, addressPrefixes: ['10.1.0.0/16'] }
}
resource hubNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = { name: '${prefix}-hub' }
resource spokeNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' existing = { name: '${prefix}-spoke' }
resource outbound 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: hubNetwork
  name: 'to-spoke'
  dependsOn: [hub]
  properties: {
    remoteVirtualNetwork: { id: spoke.outputs.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
resource inbound 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: spokeNetwork
  name: 'to-hub'
  dependsOn: [spoke]
  properties: {
    remoteVirtualNetwork: { id: hub.outputs.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output hubId string = hub.outputs.id
output spokeId string = spoke.outputs.id
