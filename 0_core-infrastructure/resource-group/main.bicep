targetScope = 'subscription'

@description('Name of the learning resource group.')
param name string
@description('Azure region for the resource group metadata.')
param location string = deployment().location
@description('Tags applied to the resource group.')
param tags object = {}

resource group 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: name
  location: location
  tags: tags
}

output id string = group.id
output name string = group.name
