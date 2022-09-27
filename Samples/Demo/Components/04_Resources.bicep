


resource landing 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: 'landingstorage'
  
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}


resource staging 'Microsoft.Storage/storageAccounts@2019-04-01' = {
  name: 'stagingstorage'

  location: resourceGroup().location
  tags: {
    Author: 'Tomaz-Kastrun'
    DateCreated: '20220928'
    Project: 'DemoNTK'
    Resource: 'PoolStorage'
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    accessTier: 'Hot'
  
  }
}



/*
// settings for Storage Resource
resource symbolicname 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: 'string'
  location: 'string'
  tags: {
    tagName1: 'tagValue1'
    tagName2: 'tagValue2'
  }
  sku: {
    name: 'string'
  }
  kind: 'string'
  extendedLocation: {
    name: 'string'
    type: 'EdgeZone'
  }
  identity: {
    type: 'string'
    userAssignedIdentities: {}
  }
  properties: {
    accessTier: 'string'
    allowBlobPublicAccess: bool
    allowCrossTenantReplication: bool
    allowedCopyScope: 'string'
    allowSharedKeyAccess: bool
    azureFilesIdentityBasedAuthentication: {
      activeDirectoryProperties: {
        accountType: 'string'
        azureStorageSid: 'string'
        domainGuid: 'string'
        domainName: 'string'
        domainSid: 'string'
        forestName: 'string'
        netBiosDomainName: 'string'
        samAccountName: 'string'
      }
      defaultSharePermission: 'string'
      directoryServiceOptions: 'string'
    }
    customDomain: {
      name: 'string'
      useSubDomainName: bool
    }
    defaultToOAuthAuthentication: bool
    dnsEndpointType: 'string'
    encryption: {
      identity: {
        federatedIdentityClientId: 'string'
        userAssignedIdentity: 'string'
      }
      keySource: 'string'
      keyvaultproperties: {
        keyname: 'string'
        keyvaulturi: 'string'
        keyversion: 'string'
      }
      requireInfrastructureEncryption: bool
      services: {
        blob: {
          enabled: bool
          keyType: 'string'
        }
        file: {
          enabled: bool
          keyType: 'string'
        }
        queue: {
          enabled: bool
          keyType: 'string'
        }
        table: {
          enabled: bool
          keyType: 'string'
        }
      }
    }
    immutableStorageWithVersioning: {
      enabled: bool
      immutabilityPolicy: {
        allowProtectedAppendWrites: bool
        immutabilityPeriodSinceCreationInDays: int
        state: 'string'
      }
    }
    isHnsEnabled: bool
    isLocalUserEnabled: bool
    isNfsV3Enabled: bool
    isSftpEnabled: bool
    keyPolicy: {
      keyExpirationPeriodInDays: int
    }
    largeFileSharesState: 'string'
    minimumTlsVersion: 'string'
    networkAcls: {
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          action: 'Allow'
          value: 'string'
        }
      ]
      resourceAccessRules: [
        {
          resourceId: 'string'
          tenantId: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: 'string'
          state: 'string'
        }
      ]
    }
    publicNetworkAccess: 'string'
    routingPreference: {
      publishInternetEndpoints: bool
      publishMicrosoftEndpoints: bool
      routingChoice: 'string'
    }
    sasPolicy: {
      expirationAction: 'Log'
      sasExpirationPeriod: 'string'
    }
    supportsHttpsTrafficOnly: bool
  }
}
*/
