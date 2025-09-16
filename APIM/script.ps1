$tenantId = "tenantid"
$subscriptionId = "suvscriptionid"

$appRegistrationName = "APIM-MCP-Script-Login"
$appSecret = ""
$appId = ""
az login --tenant $tenantId
az account set --subscription $subscriptionId

$existingApp = az ad app list --display-name $appRegistrationName | ConvertFrom-Json
if ($existingApp.Count -eq 0) { 
    $app = az ad app create --display-name $appRegistrationName | ConvertFrom-Json
    $appId = $app.appId
    Write-Host "Created new app registration with App ID: $appId"
} else {
    $appId = $existingApp[0].appId
}

Write-Host "Reset Credential App ID: $appId"
$resetPassword = az ad app credential reset --id $appId --only-show-errors | ConvertFrom-Json
$appSecret = $resetPassword.password

