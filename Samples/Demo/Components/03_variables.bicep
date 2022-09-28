
/*

Run in CLI:
az login
az group create --name RG_ntk2022 --location westeurope
az deployment group create --resource-group RG_ntk2022 --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/Demo/Components/03_variables.bicep

az group delete --name RG_ntk2022


*/


// Run 6: Configuration variables
// Name: st27

@allowed([
  'test'
  'prod'
])
param env string

var envsetting = {
  test: {
    instanceSize: 'Small'
    instanceCount: 1
    StorageSKU: 'Standard_LRS'
  }
  prod: {
    instanceSize: 'Large'
    instanceCount: 4
    StorageSKU: 'Standard_GRS'
  }
}


var instanceSKU  = envsetting[env].StorageSKU



@minLength(3)
@maxLength(11)
param storagePrefix string = 'st27'
param location string = resourceGroup().location // Lokacija vezana na resourse skupino! lahko pa jo zamenjam



/////////////////
// Variables
/////////////////


var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}${env}'



/////////////////
// Resources
////////////////

resource stg 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: instanceSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}


output storageEndpoint object = stg.properties.primaryEndpoints



/*
// similar

param environment string
param tags object

var location = resourceGroup().location
var environmentSettings = {
  prod: {
    storageAccountName: toLower('strprod${uniqueString(resourceGroup().id)}') 
    sku: 'Standard_GRS'
    publicAccess: false
  }
  test: {
    storageAccountName: toLower('strtest${uniqueString(resourceGroup().id)}') 
    sku: 'Standard_LRS'
    publicAccess: true
  }
}

resource storage 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: '${environmentSettings[environment].storageAccountName}' 
  location: location
  sku: {
    name: '${environmentSettings[environment].sku}'
  }
  kind: 'StorageV2'
  tags: tags
  properties: {
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: '${environmentSettings[environment].publicAccess}'
  } 
}

output storageAccountName string = storage.name


*/
