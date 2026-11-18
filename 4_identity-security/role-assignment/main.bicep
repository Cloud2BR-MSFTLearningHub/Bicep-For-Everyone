@description('Microsoft Entra object/principal ID, not application/client ID.')
param principalId string
@description('Role definition GUID selected for this resource group scope.')
param roleDefinitionGuid string
@description('Principal type; managed identities use ServicePrincipal.')
@allowed(['ServicePrincipal', 'User', 'Group'])
param principalType string = 'ServicePrincipal'

resource assignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, principalId, roleDefinitionGuid)
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleDefinitionGuid)
  }
}

output id string = assignment.id
