@description('Existing Key Vault name in this resource group.')
param vaultName string
@description('Existing destination Log Analytics workspace resource ID.')
param workspaceId string

resource vault 'Microsoft.KeyVault/vaults@2023-07-01' existing = { name: vaultName }
resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'audit-to-workspace'
  scope: vault
  properties: {
    workspaceId: workspaceId
    logs: [{ category: 'AuditEvent', enabled: true }]
    metrics: [{ category: 'AllMetrics', enabled: true }]
  }
}

output id string = diagnostics.id
