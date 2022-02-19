
targetScope = 'resourceGroup' 

param storageAccountName string


@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageSKU string = 'Standard_LRS'

param location string = resourceGroup().location

resource storageRes 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageAccountName
  location:  location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
}



//targetScope='subscription'
//param storageName string = 'MyMLStorage'
//param locationResource string = 'westeurope'
//param resourceGroupName string = 'MyResourceGroup'
//param resourceGroupLocation string
//resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
//  name: resourceGroupName
//  location: locationResource
//}
//resource storageAcct 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  //name: storageName
  //location: locationResource
  //scope: newRG
  //sku: {
  //  name: 'Standard_LRS'
 // }
 // kind: 'Storage'
 // properties: {}
//}

//resource MLWorkspace 'Microsoft.MachineLearning/workspaces@2019-10-01' = {
//  name: 'SampleWS'
//  location: locationResource
//  scope: newRG
//}

//module stgModule 'main.bicep' = {
//  name: storageName
//  scope: newRG
//  params: {
//    storagePrefix: 'MLtest'
//    location: newRG.location
//  }
//}


// Installation
// azure cli
// az --version
// az bicep upgrade


// run in Azure CLI (in VS Code)
// az login
// az group create --name exampleRG --location eastus
// az deployment group create --resource-group exampleRG --template-file main.bicep  --parameters storageName=storesamplerg
// az group delete --name exampleRG
