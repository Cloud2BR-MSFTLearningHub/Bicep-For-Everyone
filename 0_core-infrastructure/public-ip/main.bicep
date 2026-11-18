@description('Standard static public IP name. Public IPs incur charges.')
param name string
@description('Azure region.')
param location string = resourceGroup().location

resource address 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: name
  location: location
  sku: { name: 'Standard' }
  properties: {
    publicIPAllocationMethod: 'Static'
    publicIPAddressVersion: 'IPv4'
  }
}

output id string = address.id
output address string = address.properties.ipAddress
