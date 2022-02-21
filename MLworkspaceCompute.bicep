
targetScope = 'resourceGroup' 
param MLComputeName string
param location string = resourceGroup().location


resource MLCompute 'Microsoft.MachineLearningServices/workspaces/computes@2021-07-01' = {
  name: MLComputeName
  location: location
}
