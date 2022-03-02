# Azure Machine Learning with IaC

Exploring Azure Machine Learning with Infrastructure as Code and CI/CD 

Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources. In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. Your resources are deployed in a consistent manner. ([source](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep))

# Prerequisites

To automate this process we will need to create the following services:
1. Azure Subscription
2. Resource Group
3. Storage Account Name and Container registry
4. VNet and SubNet
5. Key Vault
6. Application Insight
7. Machine Learning Workspace

## Using Bicep to create Resource Group, Azure ML workspaces.

Login to your Azure subscription:

```bash
# connect with your created credentials
az login --use-device-code
```

and create a resource group:

```bash
az group create --name TomazKWML --location westeurope
```

And following the creation of Resource group, continue with creation of Bicep resources:

```bicep
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
```


Complete Code is available in this repository with:
1. `templateMLWS.bicep` as main bicep file
2. `nested_UpdateSubnetPolicy_vnetName_subnetName.bicep` as module for SubnetPolicy
3. `nested_privateEndpointDeploymentName.bicep` as module for privateEndpoint

With all three files set, run the command to deploy the resouces:

```bash
az deployment group create --resource-group TomazKWML --template-file ./templateMLWS.bicep
```

 ## Cloning the repository
 You can follow the steps below to clone the repository.

 ```
sudo git clone 
 ```

 ## Contact
 Get in contact if you would like to contribute or simply fork a repository and alter the code.

 ## Contributing
 Do the usual GitHub fork and pull request dance. Add yourself (or I will add you to the contributors section) if you want to. 
