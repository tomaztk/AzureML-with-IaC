/*

Run in CLI:
az login
az group create --name RG_ntk2022 --location westeurope
az deployment group create --resource-group RG_ntk2022 --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/Demo/Components/01_Components.bicep
  >> give it a longer name --- storeNTK2022
  >> give it too short name -- storeNT22
  >> name: st22
az group delete --name RG_ntk2022


*/

/////////////////
// Parameters
/////////////////


@minLength(3)
@maxLength(11)
param storagePrefix string
//param location string = resourceGroup().location // Lokacija vezana na resourse skupino! lahko pa jo zamenjam


@allowed([
  'eastus'
  'westus'
  'westeurope'
  'uksouth'
  'ukwest'
  'switzerlandnorth'
  'germanywestcentral'

])
param location string 

// Run 1

/////////////////
// Parameter decorator
/////////////////

// Run 2, comment out the SKU name (Standard_LRS)!
// name: st23

@allowed([ 
	'Standard_LRS'
	'Standard_GRS'
	'Standard_ZRS'
	'Premium_LRS'
])
param storageSKU string // = 'Standard_LRS'

// Run 3: use the allowed for locations


/////////////////
// Variables
/////////////////

// Run 4: adding en kup stvari v variablooo in dodamo še datum
//var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'

param baseTime string = utcNow('u')
var add2hours = dateTimeAdd(baseTime, 'PT2H') // UTC+2 = CEST
//var uniqueStorageName = '${storagePrefix}${add2hours}${'PROD'}' // posebni znaki

// >> st25
param convertedEpoch int = dateTimeToEpoch(dateTimeAdd(utcNow(), 'P1Y'))
var uniqueStorageName = '${storagePrefix}${convertedEpoch}${'prod'}'



/////////////////
// Resources
////////////////

resource stg 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: uniqueStorageName
  location: location
  sku: {
    name: storageSKU
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
  }
}



output storageEndpoint object = stg.properties.primaryEndpoints
