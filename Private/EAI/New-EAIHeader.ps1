function New-EAIHeader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Auth,

        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [String]$Method = 'POST'
    )

    $bearerToken = Get-EAIBearerToken -Auth $Auth

    return @{
        'Authorization' = "Bearer $bearerToken"
        'Content-Type'  = 'application/json'
        'Accept'        = 'application/json'
        '__EAIMethod'   = $Method
    }
}
