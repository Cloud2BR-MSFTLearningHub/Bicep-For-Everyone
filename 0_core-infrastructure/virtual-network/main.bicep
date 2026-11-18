@description('Virtual network name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Non-overlapping private address prefixes.')
param addressPrefixes array = ['10.20.0.0/16']
@description('Tags applied to the network.')
param tags object = {}

resource network 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: addressPrefixes }
  }
}

output id string = network.id
output name string = network.name
