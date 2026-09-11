function New-CPHeader {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [PSCustomObject]$Auth,

        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [String]$Method = 'GET'
    )

    $bearerToken = Get-CPBearerToken -Auth $Auth

    return @{
        'Authorization' = "Bearer $bearerToken"
        'Content-Type'  = 'application/json'
        'Accept'        = 'application/json'
        '__CPMethod'    = $Method
    }
}
