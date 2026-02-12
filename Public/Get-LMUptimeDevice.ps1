<#
.SYNOPSIS
Retrieves LogicMonitor Uptime devices from the v3 device endpoint.

.DESCRIPTION
The Get-LMUptimeDevice cmdlet returns Uptime monitors (web or ping) that are backed by the
LogicMonitor v3 /device/devices endpoint. It supports lookup by ID or name, optional filtering
by internal/external flag, custom filters, and the interactive filter wizard. The Type parameter
is optional and filters by webcheck or pingcheck uptime devices. If not specified, both types
are returned.

.PARAMETER Id
Specifies the identifier of the Uptime device to retrieve.

.PARAMETER Name
Specifies the name of the Uptime device to retrieve.

.PARAMETER Type
Specifies the Uptime monitor type to retrieve. Valid values are uptimewebcheck and uptimepingcheck.
If not specified, both types are returned.

.PARAMETER IsInternal
Filters results by internal (true) or external (false) monitors.

.PARAMETER Filter
Provides a filter object for advanced queries.

.PARAMETER FilterWizard
Launches the interactive filter wizard and applies the chosen filter.

.PARAMETER BatchSize
Controls the number of results returned per request. Must be between 1 and 1000. Default 1000.

.EXAMPLE
Get-LMUptimeDevice

Retrieves all Uptime devices (both webcheck and pingcheck) across the account.

.EXAMPLE
Get-LMUptimeDevice -Type uptimewebcheck

Retrieves all web Uptime devices across the account.

.EXAMPLE
Get-LMUptimeDevice -Type uptimewebcheck -IsInternal $true

Retrieves internal web Uptime devices only.

.EXAMPLE
Get-LMUptimeDevice -Name "web-int-01"

Retrieves a specific Uptime device by name.

.EXAMPLE
Get-LMUptimeDevice -Id 123

Retrieves a specific Uptime device by ID.

.NOTES
You must run Connect-LMAccount before invoking this cmdlet. Responses are tagged with the
LogicMonitor.LMUptimeDevice type information.

.INPUTS
None. You cannot pipe objects to this cmdlet.

.OUTPUTS
LogicMonitor.LMUptimeDevice

.LINK
New-LMUptimeDevice

.LINK
Set-LMUptimeDevice

.LINK
Remove-LMUptimeDevice
#>
function Get-LMUptimeDevice {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [ValidateSet('uptimewebcheck', 'uptimepingcheck')]
        [String]$Type,

        [Parameter(ParameterSetName = 'All')]
        [Nullable[bool]]$IsInternal,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return
    }

    $resourcePathRoot = '/device/devices'

    # Build deviceType filter: single value if Type specified, OR condition if not (18 = webcheck, 19 = pingcheck)
    if ($PSBoundParameters.ContainsKey('Type')) {
        $deviceTypeFilter = switch ($Type) {
            'uptimewebcheck' { 'deviceType:18' }
            'uptimepingcheck' { 'deviceType:19' }
        }
    }
    else {
        $deviceTypeFilter = 'deviceType:18|19'
    }

    $ParameterSetName = $PSCmdlet.ParameterSetName
    $SingleObjectWhenNotPaged = $ParameterSetName -eq 'Id'

    $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
        param($Offset, $PageSize)

        $RequestResourcePath = $resourcePathRoot
        $queryParams = ''

        switch ($ParameterSetName) {
            'All' {
                $filterParts = @()
                $filterParts += $deviceTypeFilter

                if ($PSBoundParameters.ContainsKey('IsInternal')) {
                    $boolValue = ([bool]$IsInternal).ToString().ToLowerInvariant()
                    $filterParts += "isInternal:$boolValue"
                }

                $filterString = $filterParts -join ','
                $queryParams = "?filter=$filterString&size=$PageSize&offset=$Offset&sort=+id"
            }
            'Id' {
                $RequestResourcePath = "$resourcePathRoot/$Id"
                $queryParams = ''
            }
            'Name' {
                $filterString = "$deviceTypeFilter,name:`"$Name`""
                $queryParams = "?filter=$filterString&size=$PageSize&offset=$Offset&sort=+id"
            }
            'Filter' {
                $filterInput = $Filter

                if ($Filter -is [hashtable]) {
                    $filterInput = @{}
                    foreach ($key in $Filter.Keys) { $filterInput[$key] = $Filter[$key] }
                }
                elseif ($Filter -is [string] -and -not [string]::IsNullOrWhiteSpace($Filter)) {
                    $filterInput = "($deviceTypeFilter,$Filter)"
                }

                $validFilter = Format-LMFilter -Filter $filterInput -ResourcePath $RequestResourcePath
                if ($validFilter) {
                    $queryParams = "?filter=$deviceTypeFilter,$validFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
                else {
                    $queryParams = "?filter=$deviceTypeFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
            }
            'FilterWizard' {
                $filterObject = Build-LMFilter -PassThru -ResourcePath $resourcePathRoot
                if (-not $filterObject) {
                    return
                }
                $validFilter = Format-LMFilter -Filter $filterObject -ResourcePath $resourcePathRoot
                if ($validFilter) {
                    $queryParams = "?filter=$deviceTypeFilter,$validFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
                else {
                    $queryParams = "?filter=$deviceTypeFilter&size=$PageSize&offset=$Offset&sort=+id"
                }
            }
        }

        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'GET' -ResourcePath $RequestResourcePath
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $queryParams

        Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation

        $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'GET' -Headers $headers[0] -WebSession $headers[1]

        if ($null -eq $response) {
            return $null
        }

        if ($ParameterSetName -eq 'Id') {
            if ($response.deviceType -notin @(18, 19)) {
                Write-Error "Device with Id $Id is not an Uptime device (deviceType: $($response.deviceType))"
                return $null
            }
            if ($PSBoundParameters.ContainsKey('Type')) {
                $expectedType = switch ($Type) {
                    'uptimewebcheck' { 18 }
                    'uptimepingcheck' { 19 }
                }
                if ($response.deviceType -ne $expectedType) {
                    Write-Error "Device with Id $Id is not of type '$Type' (deviceType: $($response.deviceType))"
                    return $null
                }
            }
            return $response
        }

        return $response
    }

    return (Add-ObjectTypeInfo -InputObject $Results -TypeName 'LogicMonitor.LMUptimeDevice')
}



