@description('Scale set name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing subnet resource ID with an explicit outbound connectivity design.')
param subnetId string
@description('SSH public key.')
param sshPublicKey string
@description('Linux administrator username.')
param administrator string = 'azureuser'
@description('Instance count.')
@minValue(0)
@maxValue(10)
param capacity int = 1

resource scaleSet 'Microsoft.Compute/virtualMachineScaleSets@2024-07-01' = {
  name: name
  location: location
  sku: { name: 'Standard_D2s_v5', tier: 'Standard', capacity: capacity }
  identity: { type: 'SystemAssigned' }
  properties: {
    orchestrationMode: 'Uniform'
    upgradePolicy: { mode: 'Manual' }
    overprovision: false
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: 'learn'
        adminUsername: administrator
        linuxConfiguration: {
          disablePasswordAuthentication: true
          ssh: { publicKeys: [{ path: '/home/${administrator}/.ssh/authorized_keys', keyData: sshPublicKey }] }
        }
      }
      storageProfile: {
        imageReference: { publisher: 'Canonical', offer: 'ubuntu-24_04-lts', sku: 'server', version: 'latest' }
        osDisk: { createOption: 'FromImage', managedDisk: { storageAccountType: 'Standard_LRS' } }
      }
      networkProfile: {
        networkInterfaceConfigurations: [{
          name: 'primary'
          properties: {
            primary: true
            ipConfigurations: [{ name: 'primary', properties: { subnet: { id: subnetId } } }]
          }
        }]
      }
    }
  }
}

output id string = scaleSet.id
