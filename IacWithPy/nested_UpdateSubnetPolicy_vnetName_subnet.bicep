param reference_variables_subnet_2019_09_01 object
param variables_subnetPolicyForPE object 

@description('Name of the VNet')
param vnetName string

@description('Name of the subnet')
param subnetName string

@description('Determines whether or not a new subnet should be provisioned.')
@allowed([
  'new'
  'existing'
  'none'
])
param subnetOption string

@allowed([
  'AutoApproval'
  'ManualApproval'
  'none'
])
param privateEndpointType string

resource vnetName_subnet 'Microsoft.Network/virtualNetworks/subnets@2019-09-01' = {
  name: '${vnetName}/${subnetName}'
  properties: (((subnetOption == 'existing') && (privateEndpointType != 'none')) ? union(reference_variables_subnet_2019_09_01, variables_subnetPolicyForPE) : json('null'))
}
