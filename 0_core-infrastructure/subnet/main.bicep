@description('Existing parent virtual network in this resource group.')
param virtualNetworkName string
@description('Subnet name.')
param name string
@description('Subnet CIDR within the virtual network address space.')
param addressPrefix string
@description('Existing network security group resource ID, or empty to omit.')
param networkSecurityGroupId string = ''
@description('Service delegations, for example Microsoft.App/environments.')
param delegatedServices array = []

resource network 'Microsoft.Network/virtualNetworks@2024-05-01' existing = {
  name: virtualNetworkName
}
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: network
  name: name
  properties: {
    addressPrefix: addressPrefix
    networkSecurityGroup: empty(networkSecurityGroupId) ? null : { id: networkSecurityGroupId }
    privateEndpointNetworkPolicies: 'Enabled'
    delegations: [for (service, index) in delegatedServices: {
      name: 'delegation-${index}'
      properties: { serviceName: service }
    }]
  }
}

output id string = subnet.id
