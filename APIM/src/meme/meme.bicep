@description('The name of the API Management service')
param apimServiceName string

resource apimService 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apimServiceName
}

resource service_apim_mcp_we_test_name_mcp_memegen 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' = {
  parent: apimService
  name: 'mcp-memegen'
  properties: {
    displayName: 'MCP Memegen'
    apiRevision: '1'
    subscriptionRequired: false
    path: 'meme-mcp'
    protocols: [
      'https'
    ]
    authenticationSettings: {
      oAuth2AuthenticationSettings: []
      openidAuthenticationSettings: []
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    type: 'mcp'
    isCurrent: true
  }
}

resource service_apim_mcp_we_test_name_memegen 'Microsoft.ApiManagement/service/apis@2024-06-01-preview' = {
  parent: apimService
  name: 'memegen'
  properties: {
    displayName: 'Memegen'
    apiRevision: '1'
    description: '\n## Quickstart\n\nFetch the list of templates:\n\n```\n$ http GET https://api.memegen.link/templates\n\n[\n    {\n        "id": "aag",\n        "name": "Ancient Aliens Guy",\n        "lines": 2,\n        "overlays": 0,\n        "styles": [],\n        "blank": "https://api.memegen.link/images/aag.png",\n        "example": {\n            "text": [\n                "",\n                "aliens"\n            ],\n            "url": "https://api.memegen.link/images/aag/_/aliens.png"\n        },\n        "source": "http://knowyourmeme.com/memes/ancient-aliens",\n    },\n    ...\n]\n```\n\nAdd text to create a meme:\n\n```\n$ http POST https://api.memegen.link/images template_id=aag "text[]=foo" "text[]=bar"\n\n{\n    "url": "https://api.memegen.link/images/aag/foo/bar.png"\n}\n```\n\nView the image: <https://api.memegen.link/images/aag/foo/bar.png>\n\n## Links\n'
    subscriptionRequired: true
    path: 'meme'
    protocols: [
      'http'
      'https'
    ]
    authenticationSettings: {
      oAuth2AuthenticationSettings: []
      openidAuthenticationSettings: []
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    contact: {
      name: 'support'
      email: 'support@maketested.com'
    }
    license: {
      name: 'View the license'
      url: 'https://github.com/jacebrowning/memegen/blob/main/LICENSE.txt'
    }
    isCurrent: true
  }
}
