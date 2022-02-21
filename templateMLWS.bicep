@description('Specifies the name of the Azure Machine Learning workspace.')
param workspaceName string

@description('Specifies the location for all resources.')
param location string

@description('Specifies the resource group name of the Azure Machine Learning workspace.')
param resourceGroupName string

@description('Specifies the sku, also referred as \'edition\' of the Azure Machine Learning workspace.')
@allowed([
  'Basic'
  'Enterprise'
])
param sku string = 'Basic'

@description('Specifies the identity type of the Azure Machine Learning workspace.')
@allowed([
  'systemAssigned'
  'userAssigned'
])
param identityType string = 'systemAssigned'

@description('Specifies the resource group of user assigned identity that represents the Azure Machine Learing workspace.')
param primaryUserAssignedIdentityResourceGroup string = resourceGroupName

@description('Specifies the name of user assigned identity that represents the Azure Machine Learing workspace.')
param primaryUserAssignedIdentityName string = ''

@description('Determines whether or not a new storage should be provisioned.')
@allowed([
  'new'
  'existing'
])
param storageAccountOption string = 'new'

@description('Name of the storage account.')
param storageAccountName string = 'sa${uniqueString(resourceGroupName, workspaceName)}'

@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
])
param storageAccountType string = 'Standard_LRS'

@description('Determines whether or not to put the storage account behind VNet')
@allowed([
  'true'
  'false'
])
param storageAccountBehindVNet string = 'false'
param storageAccountResourceGroupName string = resourceGroupName
param storageAccountLocation string = location
param storageAccountHnsEnabled bool = false

@description('Determines whether or not a new key vault should be provisioned.')
@allowed([
  'new'
  'existing'
])
param keyVaultOption string = 'new'

@description('Name of the key vault.')
param keyVaultName string = 'kv${uniqueString(resourceGroupName, workspaceName)}'

@description('Determines whether or not to put the storage account behind VNet')
@allowed([
  'true'
  'false'
])
param keyVaultBehindVNet string = 'false'
param keyVaultResourceGroupName string = resourceGroupName
param keyVaultLocation string = location

@description('Determines whether or not new ApplicationInsights should be provisioned.')
@allowed([
  'new'
  'existing'
])
param applicationInsightsOption string = 'new'

@description('Name of ApplicationInsights.')
param applicationInsightsName string = 'ai${uniqueString(resourceGroupName, workspaceName)}'
param applicationInsightsResourceGroupName string = resourceGroupName
param applicationInsightsLocation string = location

@description('Determines whether or not a new container registry should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param containerRegistryOption string = 'none'

@description('The container registry bind to the workspace.')
param containerRegistryName string = 'cr${uniqueString(resourceGroupName, workspaceName)}'

@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param containerRegistrySku string = 'Standard'
param containerRegistryResourceGroupName string = resourceGroupName

@description('Determines whether or not to put container registry behind VNet.')
@allowed([
  'true'
  'false'
])
param containerRegistryBehindVNet string = 'false'
param containerRegistryLocation string = location

@description('Determines whether or not a new VNet should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param vnetOption string = ((privateEndpointType == 'none') ? 'none' : 'new')

@description('Name of the VNet')
param vnetName string = 'vn${uniqueString(resourceGroupName, workspaceName)}'
param vnetResourceGroupName string = resourceGroupName

@description('Address prefix of the virtual network')
param addressPrefixes array = [
  '10.0.0.0/16'
]

@description('Determines whether or not a new subnet should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param subnetOption string = (((privateEndpointType != 'none') || (vnetOption == 'new')) ? 'new' : 'none')

@description('Name of the subnet')
param subnetName string = 'sn${uniqueString(resourceGroupName, workspaceName)}'

@description('Subnet prefix of the virtual network')
param subnetPrefix string = '10.0.0.0/24'

@description('Azure Databrick workspace to be linked to the workspace')
param adbWorkspace string = ''

@description('Specifies that the Azure Machine Learning workspace holds highly confidential data.')
@allowed([
  'false'
  'true'
])
param confidential_data string = 'false'

@description('Specifies if the Azure Machine Learning workspace should be encrypted with customer managed key.')
@allowed([
  'Enabled'
  'Disabled'
])
param encryption_status string = 'Disabled'

@description('Specifies the customer managed keyVault arm id.')
param cmk_keyvault string = ''

@description('Specifies if the customer managed keyvault key uri.')
param resource_cmk_uri string = ''

@description('Specifies bring your own storage account id for customer managed keys')
param cmk_storageAccountId string = ''

@description('Specifies bring your own search service id for customer managed keys')
param cmk_searchAccountId string = ''

@description('Specifies bring your own cosmos DB id for customer managed keys')
param cmk_cosmosDbId string = ''

@allowed([
  'AutoApproval'
  'ManualApproval'
  'none'
])
param privateEndpointType string = 'none'
param tagValues object

@description('Name of the private end point added to the workspace')
param privateEndpointName string = 'pe'

@description('Name of the resource group where the private end point is added to')
param privateEndpointResourceGroupName string = resourceGroupName

@description('Id of the subscription where the private end point is added to')
param privateEndpointSubscription string = subscription().subscriptionId

@description('Identity type of storage account services.')
param systemDatastoresAuthMode string = 'accessKey'

var tenantId = subscription().tenantId
var storageAccount = resourceId(storageAccountResourceGroupName, 'Microsoft.Storage/storageAccounts', storageAccountName)
var keyVault = resourceId(keyVaultResourceGroupName, 'Microsoft.KeyVault/vaults', keyVaultName)
var containerRegistry = resourceId(containerRegistryResourceGroupName, 'Microsoft.ContainerRegistry/registries', containerRegistryName)
var applicationInsights = resourceId(applicationInsightsResourceGroupName, 'Microsoft.Insights/components', applicationInsightsName)
var vnet = resourceId(privateEndpointSubscription, vnetResourceGroupName, 'Microsoft.Network/virtualNetworks', vnetName)
var subnet = resourceId(privateEndpointSubscription, vnetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', vnetName, subnetName)
var enablePE = true
var networkRuleSetBehindVNet = {
  defaultAction: 'deny'
  virtualNetworkRules: [
    {
      action: 'Allow'
      id: subnet
    }
  ]
}
var subnetPolicyForPE = {
  privateEndpointNetworkPolicies: 'Disabled'
  privateLinkServiceNetworkPolicies: 'Enabled'
}
var privateEndpointSettings = {
  name: '${workspaceName}-PrivateEndpoint'
  properties: {
    privateLinkServiceId: workspaceName_resource.id
    groupIds: [
      'amlworkspace'
    ]
  }
}
var defaultPEConnections = array(privateEndpointSettings)
var privateEndpointDeploymentName_var = 'DeployPrivateEndpoint-${uniqueString(privateEndpointName)}'
var userAssignedIdentities = {
  '${primaryUserAssignedIdentity}': {}
}
var primaryUserAssignedIdentity = resourceId(primaryUserAssignedIdentityResourceGroup, 'Microsoft.ManagedIdentity/userAssignedIdentities', primaryUserAssignedIdentityName)
var appInsightsLogWorkspaceDeploymentName = 'DeployLogWorkspace-${uniqueString(applicationInsightsName)}'

module UpdateSubnetPolicy_vnetName_subnetName './nested_UpdateSubnetPolicy_vnetName_subnetName.bicep' = if ((subnetOption == 'existing') && (privateEndpointType != 'none')) {
  name: 'UpdateSubnetPolicy-${uniqueString(vnetName, subnetName)}'
  scope: resourceGroup(privateEndpointSubscription, vnetResourceGroupName)
  params: {
    reference_variables_subnet_2019_09_01: reference(subnet, '2019-09-01')
    variables_subnetPolicyForPE: subnetPolicyForPE
    vnetName: vnetName
    subnetName: subnetName
    subnetOption: subnetOption
    privateEndpointType: privateEndpointType
  }
}

resource storageAccountName_resource 'Microsoft.Storage/storageAccounts@2019-04-01' = if (enablePE && (storageAccountOption == 'new')) {
  name: storageAccountName
  tags: tagValues
  location: storageAccountLocation
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    encryption: {
      services: {
        blob: {
          enabled: true
        }
        file: {
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    supportsHttpsTrafficOnly: true
    networkAcls: ((storageAccountBehindVNet == 'true') ? networkRuleSetBehindVNet : json('null'))
    isHnsEnabled: storageAccountHnsEnabled
  }
}

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2019-09-01' = if (enablePE && (keyVaultOption == 'new')) {
  tags: tagValues
  name: keyVaultName
  location: keyVaultLocation
  properties: {
    tenantId: tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: []
    networkAcls: ((keyVaultBehindVNet == 'true') ? networkRuleSetBehindVNet : json('null'))
  }
}

resource containerRegistryName_resource 'Microsoft.ContainerRegistry/registries@2019-05-01' = if (enablePE && (containerRegistryOption == 'new')) {
  tags: tagValues
  name: containerRegistryName
  location: containerRegistryLocation
  sku: {
    name: containerRegistrySku
  }
  properties: {
    adminUserEnabled: true
    networkRuleSet: ((containerRegistryBehindVNet == 'true') ? networkRuleSetBehindVNet : json('null'))
  }
}

resource applicationInsightsName_resource 'Microsoft.Insights/components@2018-05-01-preview' = if (enablePE && (applicationInsightsOption == 'new')) {
  tags: tagValues
  name: applicationInsightsName
  location: (((applicationInsightsLocation == 'westcentralus') || (applicationInsightsLocation == 'eastus2euap') || (applicationInsightsLocation == 'centraluseuap') || (applicationInsightsLocation == 'westus3')) ? 'southcentralus' : applicationInsightsLocation)
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

resource workspaceName_resource 'Microsoft.MachineLearningServices/workspaces@2020-06-01' = if (enablePE) {
  tags: tagValues
  name: workspaceName
  location: location
  identity: {
    type: identityType
    userAssignedIdentities: ((identityType == 'userAssigned') ? userAssignedIdentities : json('null'))
  }
  sku: {
    tier: sku
    name: sku
  }
  properties: {
    friendlyName: workspaceName
    storageAccount: storageAccount
    keyVault: keyVault
    applicationInsights: applicationInsights
    containerRegistry: ((containerRegistryOption != 'none') ? containerRegistry : json('null'))
    primaryUserAssignedIdentity: ((identityType == 'userAssigned') ? primaryUserAssignedIdentity : json('null'))
    systemDatastoresAuthMode: ((systemDatastoresAuthMode != 'accessKey') ? systemDatastoresAuthMode : json('null'))
  }
  dependsOn: [
    storageAccountName_resource
    keyVaultName_resource
    applicationInsightsName_resource
    containerRegistryName_resource
  ]
}

module privateEndpointDeploymentName './nested_privateEndpointDeploymentName.bicep' = if (enablePE && (privateEndpointType != 'none')) {
  name: privateEndpointDeploymentName_var
  scope: resourceGroup(privateEndpointSubscription, privateEndpointResourceGroupName)
  params: {
    variables_defaultPEConnections: defaultPEConnections
    variables_subnet: subnet
    privateEndpointName: privateEndpointName
    location: location
    tagValues: tagValues
    privateEndpointType: privateEndpointType
  }
}

output PrivateEndPointNotSupport string = 'Private endpoint is not supported in the specified location.'
