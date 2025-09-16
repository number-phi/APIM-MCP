// ------------------
//    PARAMETERS
// ------------------

param apimSku string
param apimSubscriptionsConfig array = []

@description('The client ID for Entra ID app registration')
param entraIDClientId string

@description('The client secret for Entra ID app registration')
@secure()
param entraIDClientSecret string

@description('The required scopes for authorization')
param oauthScopes string

@description('The encryption IV for session token')
@secure()
param encryptionIV string

@description('The encryption key for session token')
@secure()
param encryptionKey string

@description('The MCP client ID')
param mcpClientId string

param location string = resourceGroup().location

param apimName string
// ------------------
//    VARIABLES
// ------------------

var resourceSuffix = uniqueString(subscription().id, resourceGroup().id)

// ------------------
//    RESOURCES
// ------------------

// 1. Log Analytics Workspace
// module lawModule 'modules/operational-insights/v1/workspaces.bicep' = {
//   name: 'lawModule'
// }

// // 2. Application Insights
// module appInsightsModule 'modules/monitor/v1/appinsights.bicep' = {
//   name: 'appInsightsModule'
//   params: {
//     lawId: lawModule.outputs.id
//     customMetricsOptedInType: 'WithDimensions'
//   }
// }

// // 3. API Management
// module apimModule 'modules/apim/v2/apim.bicep' = {
//   name: 'apimModule'
//   params: {
//     apimSku: apimSku
//     apimSubscriptionsConfig: apimSubscriptionsConfig
//     lawId: lawModule.outputs.id
//     appInsightsId: appInsightsModule.outputs.id
//     appInsightsInstrumentationKey: appInsightsModule.outputs.instrumentationKey
//   }
// }

// resource apimService 'Microsoft.ApiManagement/service@2024-06-01-preview' existing = {
//   name: 'apim-${resourceSuffix}'
//   dependsOn: [
//     apimModule
//   ]
// }
resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimName
}

module oauthAPIModule 'src/apim-oauth/oauth.bicep' = {
  name: 'oauthAPIModule'
  params: {    
    apimServiceName: apimName
    entraIDTenantId: subscription().tenantId
    entraIDClientId: entraIDClientId
    entraIDClientSecret: entraIDClientSecret
    oauthScopes: oauthScopes
    encryptionIV: encryptionIV
    encryptionKey: encryptionKey
    mcpClientId: mcpClientId
  }
  dependsOn: []
}


// ------------------
//    OUTPUTS
// ------------------

// output applicationInsightsAppId string = appInsightsModule.outputs.appId
// output applicationInsightsName string = appInsightsModule.outputs.applicationInsightsName
// output logAnalyticsWorkspaceId string = lawModule.outputs.customerId

output apimServiceId string = apimService.id
output apimResourceName string = apimService.name
output apimResourceGatewayURL string = apimService.properties.gatewayUrl

// output apimSubscriptions array = apimModule.outputs.apimSubscriptions

