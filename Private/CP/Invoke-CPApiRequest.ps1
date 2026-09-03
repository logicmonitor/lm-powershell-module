function Invoke-CPApiRequest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$ResourcePath,

        [ValidateSet('GET', 'POST', 'PATCH', 'PUT', 'DELETE')]
        [String]$Method = 'GET',

        [Hashtable]$QueryParameters,

        $Body,

        [String]$ItemPropertyName,

        [String]$TypeName,

        [System.Management.Automation.PSCmdlet]$CallerPSCmdlet,

        [System.Management.Automation.InvocationInfo]$Command
    )

    $headers = New-CPHeader -Auth $Script:CPAuth -Method $Method
    $uri = Join-CPUri -PortalUrl $Script:CPAuth.PortalUrl -ResourcePath $ResourcePath -QueryString (New-CPQueryString -Parameters $QueryParameters)
    $jsonBody = $null
    if ($PSBoundParameters.ContainsKey('Body') -and $null -ne $Body) {
        $jsonBody = ConvertTo-CPJsonBody -InputObject $Body
    }

    if ($Command) {
        Resolve-CPDebugInfo -Url $uri -Headers $headers -Command $Command -Payload $jsonBody
    }

    $invokeParams = @{
        Uri                 = $uri
        Method              = $Method
        Headers             = $headers
        Auth                = $Script:CPAuth
        EnableDebugLogging  = ($DebugPreference -ne 'SilentlyContinue')
        CallerPSCmdlet      = $CallerPSCmdlet
    }

    if ($jsonBody) {
        $invokeParams.Body = $jsonBody
    }

    $response = Invoke-CPRestMethod @invokeParams

    if ($ItemPropertyName) {
        $page = Get-CPResponseItems -Response $response -ItemPropertyName $ItemPropertyName
        if ($page.Items.Count -eq 0) {
            Write-Output @() -NoEnumerate
            return
        }

        if ($TypeName) {
            if ($page.Items.Count -eq 1) {
                return (Add-ObjectTypeInfo -InputObject $page.Items[0] -TypeName $TypeName)
            }

            return (Add-ObjectTypeInfo -InputObject $page.Items -TypeName $TypeName)
        }

        return $page.Items
    }

    $data = Get-CPResponseData -Response $response
    if ($null -eq $data) {
        return
    }

    if ($TypeName) {
        return (Add-ObjectTypeInfo -InputObject $data -TypeName $TypeName)
    }

    return $data
}
