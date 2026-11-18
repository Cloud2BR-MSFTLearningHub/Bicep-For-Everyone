@description('Route table name.')
param name string
@description('Azure region.')
param location string = resourceGroup().location
@description('Routes with name and properties containing addressPrefix and nextHopType.')
param routes array = []

resource table 'Microsoft.Network/routeTables@2024-05-01' = {
  name: name
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: routes
  }
}

output id string = table.id
