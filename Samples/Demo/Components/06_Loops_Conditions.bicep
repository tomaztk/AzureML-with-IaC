
/*

Run in CLI:
az login
az group create --name RG_ntk2022 --location westeurope
az deployment group create --resource-group RG_ntk2022 --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/Demo/Components/06_Loops_Conditions.bicep

az group delete --name RG_ntk2022


*/

/// /// /// /// /// /// 
/// looping 
/// /// /// /// /// /// 

/// Demo 1
// param itemCount int = 5

// var stringArray = [for i in range(0, itemCount): 'item${(i + 1)}']

// output arrayResult array = stringArray



/// Demo 2

// creating two storage accounts using loop
// param location string = resourceGroup().location
// param storageCount int = 2

// resource storageAcct 'Microsoft.Storage/storageAccounts@2019-04-01' = [for i in range(0, storageCount): {
//   name: '${i}storage${uniqueString(resourceGroup().id)}'
//   location: location
//   sku: {
//     name: 'Standard_LRS'
//   }
//   kind: 'Storage'
// }]

// output storageInfo array = [for i in range(0, storageCount): {
//   id: storageAcct[i].id
//   blobEndpoint: storageAcct[i].properties.primaryEndpoints.blob
//   status: storageAcct[i].properties.statusOfPrimary
// }]



/// Demo 3 
/// Create per groups in organisation

// name: st30

// param storageAccountNamePrefix string

// var storageConfigurations = [
//   {
//     suffix: 'devteam'
//     sku: 'Standard_LRS'
//   }
//   {
//     suffix: 'dsteam'
//     sku: 'Standard_LRS'
//   }
// ]

// resource storageAccountResources 'Microsoft.Storage/storageAccounts@2021-06-01' = [for (config, i) in storageConfigurations: {
//   name: '${storageAccountNamePrefix}${config.suffix}${i}'
//   location: resourceGroup().location
//   sku: {
//     name: config.sku
//   }
//   kind: 'StorageV2'
// }]




/// /// /// /// /// /// 
/// IFing 
/// /// /// /// /// /// 


param storageAccountName string = 'st31ifstorage'
param location string = resourceGroup().location

@allowed([
  'prod'
  'test'
])
param isTestOrProd string

resource sa 'Microsoft.Storage/storageAccounts@2019-06-01' = if ( isTestOrProd == 'prod') {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  tags: {
    Author: 'Tomaz-Kastrun'
    DateCreated: '20220928'
    Project: 'DemoNTK'
    Resource: 'PoolStorage'
    Whatever: 'ResolvedPROD'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}


output VrednostIF string = isTestOrProd
