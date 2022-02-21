
@description('Location for all resources.')
param location string = resourceGroup().location


// storage

param storageAccountName string
param containerName string = 'logs'

resource sa 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2019-06-01' = {
  name: '${sa.name}/default/${containerName}'
}

// workspace

param WorkspaceName string

resource MLworkspace 'Microsoft.MachineLearning/workspaces@2016-04-01' = {
  name: WorkspaceName
  location: location
  tags: {
    Author: 'TomazKastun'
    Project: 'testBiceps'
  }
  properties: {
    ownerEmail: 'tomaz.kastrun@gmail.com'
    userStorageAccountId: storageAccountName
  }
}
