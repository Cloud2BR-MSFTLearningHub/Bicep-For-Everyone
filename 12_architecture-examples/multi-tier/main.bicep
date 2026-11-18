@description('Short naming prefix.')
param prefix string
@description('Azure region.')
param location string = resourceGroup().location

module network '../../0_core-infrastructure/virtual-network/main.bicep' = {
  name: 'network'
  params: { name: '${prefix}-vnet', location: location, addressPrefixes: ['10.40.0.0/16'] }
}
var tiers = [
  { name: 'web', prefix: '10.40.1.0/24', source: '10.40.1.0/24', port: '443' }
  { name: 'application', prefix: '10.40.2.0/24', source: '10.40.1.0/24', port: '8443' }
  { name: 'data', prefix: '10.40.3.0/24', source: '10.40.2.0/24', port: '5432' }
]
module groups '../../0_core-infrastructure/network-security-group/main.bicep' = [for tier in tiers: {
  name: '${tier.name}-nsg'
  params: {
    name: '${prefix}-${tier.name}-nsg'
    location: location
    securityRules: [
      {
        name: 'AllowTier'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: tier.port
          sourceAddressPrefix: tier.source
          destinationAddressPrefix: tier.prefix
        }
      }
      {
        name: 'DenyOtherInbound'
        properties: {
          priority: 4096
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}]
@batchSize(1)
module subnets '../../0_core-infrastructure/subnet/main.bicep' = [for (tier, index) in tiers: {
  name: '${tier.name}-subnet'
  params: {
    name: tier.name
    virtualNetworkName: network.outputs.name
    addressPrefix: tier.prefix
    networkSecurityGroupId: groups[index].outputs.id
  }
}]

output subnetIds array = [for (_, index) in tiers: subnets[index].outputs.id]
