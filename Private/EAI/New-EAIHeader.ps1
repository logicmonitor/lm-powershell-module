function New-EAIHeader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Auth,

        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [String]$Method = 'POST'
    )

    $clientId = [System.Net.NetworkCredential]::new('', $Auth.ClientSecret).Password
    $credentials = "$($Auth.ClientId):$clientId"
    $token = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($credentials))

    return @{
        'Authorization' = "Basic $token"
        'Content-Type'  = 'application/json'
        'Accept'        = 'application/json'
        '__EAIMethod'   = $Method
    }
}
