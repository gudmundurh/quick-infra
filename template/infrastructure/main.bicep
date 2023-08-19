param location string = resourceGroup().location

@description('Name for the app')
param appName string = resourceGroup().name

param storageName string = 'database${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource app 'Microsoft.Web/staticSites@2022-03-01' = {
  name: appName
  location: location
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {}
  
  resource swaCfg 'config' = {
    name: 'appsettings'
    properties: {
      storage: 'DefaultEndpointsProtocol=https;AccountName=${storage.name};AccountKey=${storage.listKeys().keys[0].value}'
    }
  }
}

output hostname string = app.properties.defaultHostname
