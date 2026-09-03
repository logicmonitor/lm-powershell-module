function Get-CPResponseData {
    [CmdletBinding()]
    param(
        $Response
    )

    if ($null -eq $Response) {
        return $null
    }

    if ($Response -is [PSCustomObject] -and $null -ne $Response.PSObject.Properties['data']) {
        return $Response.data
    }

    return $Response
}
