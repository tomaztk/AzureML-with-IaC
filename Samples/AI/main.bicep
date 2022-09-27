// az deployment group create --resource-group RG_tomazKWML --template-file /Users/tomazkastrun/Documents/tomaztk_github/AzureML-with-IaC/Samples/AI/main.bicep

@minLength(3)
@maxLength(24)
param storageName string

resource AIStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storageName
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}
