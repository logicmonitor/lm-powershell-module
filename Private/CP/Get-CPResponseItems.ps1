function Get-CPResponseItems {
    [CmdletBinding()]
    param(
        $Response,

        [String]$ItemPropertyName
    )

    $result = [PSCustomObject]@{
        Items   = @()
        HasMore = $false
        Next    = $null
    }

    if ($null -eq $Response) {
        return $result
    }

    $payload = $Response
    if ($Response -is [PSCustomObject] -and $null -ne $Response.PSObject.Properties['data'] -and $null -ne $Response.data) {
        $payload = $Response.data
    }

    if ($payload -is [System.Array]) {
        $result.Items = @($payload)
        return $result
    }

    if ($ItemPropertyName -and $null -ne $payload.PSObject.Properties[$ItemPropertyName] -and $null -ne $payload.$ItemPropertyName) {
        $result.Items = @($payload.$ItemPropertyName)
    }
    elseif ($null -ne $payload.PSObject.Properties['id'] -or $null -ne $payload.PSObject.Properties['name']) {
        $result.Items = @($payload)
    }

    if ($null -ne $payload.PSObject.Properties['hasMore'] -and $payload.hasMore) {
        $result.HasMore = [bool]$payload.hasMore
    }

    if ($null -ne $payload.PSObject.Properties['next'] -and -not [string]::IsNullOrWhiteSpace([string]$payload.next)) {
        $result.Next = [string]$payload.next
    }

    return $result
}
