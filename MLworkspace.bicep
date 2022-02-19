
targetScope = 'resourceGroup' 
param WorkspaceName string
param location string = resourceGroup().location

resource MLworkspace 'Microsoft.MachineLearning/workspaces@2019-10-01' = {
  name: WorkspaceName
  location: location
}
