@description('Virtual machine name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Existing subnet resource ID. No public IP is created.')
param subnetId string
@description('SSH public key, never a private key.')
param sshPublicKey string
@description('Linux administrator username.')
param administrator string = 'azureuser'
@description('VM size available in your region and quota.')
param vmSize string = 'Standard_B2s'

resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: '${name}-nic'
  location: location
  properties: {
    ipConfigurations: [{
      name: 'primary'
      properties: { privateIPAllocationMethod: 'Dynamic', subnet: { id: subnetId } }
    }]
  }
}
resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: name
  location: location
  identity: { type: 'SystemAssigned' }
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: name
      adminUsername: administrator
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: { publicKeys: [{ path: '/home/${administrator}/.ssh/authorized_keys', keyData: sshPublicKey }] }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'ubuntu-24_04-lts'
        sku: 'server'
        version: 'latest'
      }
      osDisk: { createOption: 'FromImage', managedDisk: { storageAccountType: 'Standard_LRS' }, deleteOption: 'Delete' }
    }
    networkProfile: { networkInterfaces: [{ id: nic.id, properties: { deleteOption: 'Delete' } }] }
    securityProfile: { securityType: 'TrustedLaunch', uefiSettings: { secureBootEnabled: true, vTpmEnabled: true } }
  }
}

output id string = vm.id
