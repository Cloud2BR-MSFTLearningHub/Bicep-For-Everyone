@description('Network security group name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Explicit security rules. The default adds a deny-all inbound rule.')
param securityRules array = [
  {
    name: 'DenyAllInbound'
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

resource group 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: name
  location: location
  properties: { securityRules: securityRules }
}

output id string = group.id
