
/*

Run in CLI:
az login
az group create --name RG_ntk2022 --location westeurope
az deployment group create --resource-group RG_ntk2022 --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/Demo/Components/02_ObjectParameters.bicep

az group delete --name RG_ntk2022


*/


// Run 5: objects as parameters
// Adding VnetSettings as parameter + adding resource vnet!
// Name: st26

param locationVnet string = resourceGroup().location // Lokacija vezana na resourse skupino! lahko pa jo zamenjam

param vNetSettings object = {
  name: 'VNet1'
  location: locationVnet
    addressPrefixes: [
      {
        name: 'Primarni_Prefix'
        addressPrefix: '10.0.0.0/22'
      }
    ]

    subnets: [
      {
        name: 'Primarni_Subnet'
        addressPrefix: '10.0.0.0/24'
      }
      {
        name: 'Sekundardni_subnet'
        addressPrefix: '10.0.1.0/24'
      }
    ]
}


@minLength(3)
@maxLength(11)
param storagePrefix string
param location string = resourceGroup().location // Lokacija vezana na resourse skupino! lahko pa jo zamenjam

// Run 1

/////////////////
// Parameter decorator
/////////////////


param storageSKU string  = 'Standard_LRS'


/////////////////
// Variables
/////////////////


var uniqueStorageName = '${storagePrefix}${uniqueString(resourceGroup().id)}'



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


/*
Adding virtual network resource!
*/
resource vnet 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vNetSettings.name
  location: vNetSettings.location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vNetSettings.addressPrefixes[0].addressPrefix
      ]
    }
    subnets: [
      {
        name: vNetSettings.subnets[0].name
        properties: {
          addressPrefix: vNetSettings.subnets[0].addressPrefix
        }
      }
      {
        name: vNetSettings.subnets[1].name
        properties: {
          addressPrefix: vNetSettings.subnets[1].addressPrefix
        }
      }
    ]
  }
}



output storageEndpoint object = stg.properties.primaryEndpoints
