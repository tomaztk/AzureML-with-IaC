// =========== main.bicep ===========

// Parameters
param storageName string = 'MyMLStorage'
param locationResource string = 'westeurope'
param resourceGroupName string = 'MyResourceGroup'
param WorkspaceName string = 'MLAzureWorksSpace'

// Setting target scope
targetScope = 'subscription'

// Creating resource group
resource newRG 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: resourceGroupName
  location: locationResource
}

// Deploying storage account using module
module storageRes './storage.bicep' = {
  name: storageName
  scope: newRG    // Deployed in the scope of resource group we created above
  params: {
    storageAccountName: 'dbpystorage'
    location: locationResource
  }
}

// Deploying Workspace using this module
module MLwsRes'./MLworkspace.bicep' = {
  name: WorkspaceName
  scope: newRG  
  params:{
    WorkspaceName: WorkspaceName
    location: locationResource
  }
 }



