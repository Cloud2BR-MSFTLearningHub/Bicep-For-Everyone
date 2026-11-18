@description('Globally unique web app name; also used as a naming prefix.')
param name string
@description('Azure region.')
param location string = resourceGroup().location

module network '../../0_core-infrastructure/virtual-network/main.bicep' = {
  name: 'network'
  params: { name: '${name}-vnet', location: location }
}
module subnet '../../0_core-infrastructure/subnet/main.bicep' = {
  name: 'endpoint-subnet'
  params: { name: 'endpoints', virtualNetworkName: network.outputs.name, addressPrefix: '10.20.1.0/24' }
}
module web '../../2_compute-containers/app-service/main.bicep' = {
  name: 'web'
  params: { name: name, location: location }
}
module dns '../../3_networking/private-dns/main.bicep' = {
  name: 'dns'
  params: { name: 'privatelink.azurewebsites.net', virtualNetworkId: network.outputs.id }
}
module endpoint '../../3_networking/private-endpoint/main.bicep' = {
  name: 'endpoint'
  params: {
    name: '${name}-pe'
    location: location
    subnetId: subnet.outputs.id
    targetResourceId: web.outputs.id
    groupId: 'sites'
    privateDnsZoneId: dns.outputs.id
  }
}

output hostname string = web.outputs.hostname
output appId string = web.outputs.id
