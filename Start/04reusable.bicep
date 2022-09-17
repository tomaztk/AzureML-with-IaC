param storageAccountName string
param accessTier string = 'Hot'
param location string = 'WestUS2'

resource sa 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: accessTier
  }
}
