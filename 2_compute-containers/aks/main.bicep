@description('AKS cluster name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('DNS prefix.')
param dnsPrefix string = name
@description('Microsoft Entra administrator group object IDs.')
@minLength(1)
param administratorGroupIds array

resource cluster 'Microsoft.ContainerService/managedClusters@2024-10-01' = {
  name: name
  location: location
  identity: { type: 'SystemAssigned' }
  sku: { name: 'Base', tier: 'Free' }
  properties: {
    dnsPrefix: dnsPrefix
    enableRBAC: true
    disableLocalAccounts: true
    aadProfile: {
      managed: true
      enableAzureRBAC: true
      adminGroupObjectIDs: administratorGroupIds
      tenantID: tenant().tenantId
    }
    apiServerAccessProfile: { enablePrivateCluster: true }
    oidcIssuerProfile: { enabled: true }
    securityProfile: { workloadIdentity: { enabled: true } }
    agentPoolProfiles: [{
      name: 'system'
      count: 1
      vmSize: 'Standard_D2s_v5'
      osType: 'Linux'
      osSKU: 'AzureLinux'
      mode: 'System'
      type: 'VirtualMachineScaleSets'
    }]
    networkProfile: { networkPlugin: 'azure', networkPluginMode: 'overlay', loadBalancerSku: 'standard', outboundType: 'loadBalancer' }
  }
}

output id string = cluster.id
