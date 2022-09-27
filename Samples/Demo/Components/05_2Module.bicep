
/*

Run in CLI:
az login
az group create --name RG_ntk2022 --location westeurope
az deployment group create --resource-group RG_ntk2022 --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/Demo/Components/05_2Module.bicep

az group delete --name RG_ntk2022


*/

// name: st28


@minLength(3)
@maxLength(11)
param namePrefix string


module stgModule '../Components/05_1ResourceModules.bicep' = {
  name: 'storageDeploy'
  params: {
    storagePrefix: namePrefix
    location: resourceGroup().location 
  }
}

output storageEndpoint object = stgModule.outputs.storageEndpoint
