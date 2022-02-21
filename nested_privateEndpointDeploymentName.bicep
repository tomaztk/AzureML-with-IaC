param variables_defaultPEConnections ? /* TODO: fill in correct type */
param variables_subnet ? /* TODO: fill in correct type */

@description('Name of the private end point added to the workspace')
param privateEndpointName string

@description('Specifies the location for all resources.')
param location string
param tagValues object

@allowed([
  'AutoApproval'
  'ManualApproval'
  'none'
])
param privateEndpointType string

resource privateEndpointName_resource 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  name: privateEndpointName
  location: location
  tags: tagValues
  properties: {
    privateLinkServiceConnections: ((privateEndpointType == 'AutoApproval') ? variables_defaultPEConnections : json('null'))
    manualPrivateLinkServiceConnections: ((privateEndpointType == 'ManualApproval') ? variables_defaultPEConnections : json('null'))
    subnet: {
      id: variables_subnet
    }
  }
}
