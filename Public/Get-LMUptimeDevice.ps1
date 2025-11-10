<#
.SYNOPSIS
Retrieves LogicMonitor Uptime devices from the v3 device endpoint.

.DESCRIPTION
The Get-LMUptimeDevice cmdlet returns Uptime monitors (web or ping) that are backed by the
LogicMonitor v3 /device/devices endpoint. It supports lookup by ID or name, optional filtering
by type or internal/external flag, custom filters, and the interactive filter wizard. All
requests automatically enforce the Uptime model so only websiteDevice resources are returned.

.PARAMETER Id
Specifies the identifier of the Uptime device to retrieve.

.PARAMETER Name
Specifies the name of the Uptime device to retrieve.

.PARAMETER Type
Filters results by Uptime monitor type. Valid values are webcheck and pingcheck.

.PARAMETER IsInternal
Filters results by internal (true) or external (false) monitors.

.PARAMETER Filter
Provides a filter object for advanced queries. The Uptime model constraint is applied
automatically in addition to the supplied criteria.

.PARAMETER FilterWizard
Launches the interactive filter wizard and applies the chosen filter along with the Uptime
model constraint.

.PARAMETER BatchSize
Controls the number of results returned per request. Must be between 1 and 1000. Default 1000.

.EXAMPLE
Get-LMUptimeDevice

Retrieves all Uptime devices across the account.

.EXAMPLE
Get-LMUptimeDevice -Type webcheck -IsInternal $true

Retrieves internal web Uptime devices only.

.EXAMPLE
Get-LMUptimeDevice -Name "web-int-01"

Retrieves a specific Uptime device by name.

.NOTES
You must run Connect-LMAccount before invoking this cmdlet. Responses are tagged with the
LogicMonitor.LMUptimeDevice type information.

.OUTPUTS
LogicMonitor.LMUptimeDevice
#>
function Get-LMUptimeDevice {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'All')]
        [ValidateSet('webcheck', 'pingcheck')]
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
    $deviceTypeWebClause = 'deviceType:%2218%22'
    $deviceTypePingClause = 'deviceType:%2219%22'
    $deviceTypeCombinedClause = 'deviceType:%2218%22|%2219%22'

    $queryParams = ''
    $count = 0
    $done = $false
    $results = @()

    while (-not $done) {
        $resourcePath = $resourcePathRoot
        $queryParams = ''

        switch ($PSCmdlet.ParameterSetName) {
            'All' {
                $deviceTypeClause = switch ($Type) {
                    'webcheck' { $deviceTypeWebClause }
                    'pingcheck' { $deviceTypePingClause }
                    default { $deviceTypeCombinedClause }
                }

                $filterParts = @($deviceTypeClause)

                if ($PSBoundParameters.ContainsKey('IsInternal')) {
                    $boolValue = ([bool]$IsInternal).ToString().ToLowerInvariant()
                    $filterParts += "isInternal:$boolValue"
                }

                $filterString = $filterParts -join ','
                $queryParams = "?filter=$filterString&size=$BatchSize&offset=$count&sort=+id"
            }
            'Id' {
                $resourcePath = "$resourcePath/$Id"
            }
            'Name' {
                $filterString = "$deviceTypeCombinedClause,name:%22$Name%22"
                $queryParams = "?filter=$filterString&size=$BatchSize&offset=$count&sort=+id"
            }
            'Filter' {
                $filterInput = $Filter

                if ($Filter -is [hashtable]) {
                    $filterInput = @{}
                    foreach ($key in $Filter.Keys) { $filterInput[$key] = $Filter[$key] }
                }
                elseif ($Filter -is [string] -and -not [string]::IsNullOrWhiteSpace($Filter)) {
                    $filterInput = "($Filter)"
                }

                $validFilter = Format-LMFilter -Filter $filterInput -ResourcePath $resourcePath
                if ($validFilter) {
                    if ($validFilter -notlike '*deviceType%22*') {
                        $validFilter = "$validFilter,$deviceTypeCombinedClause"
                    }
                }
                else {
                    $validFilter = $deviceTypeCombinedClause
                }

                $queryParams = "?filter=$validFilter&size=$BatchSize&offset=$count&sort=+id"
            }
            'FilterWizard' {
                $filterObject = Build-LMFilter -PassThru -ResourcePath $resourcePathRoot
                if (-not $filterObject) {
                    return
                }
                $validFilter = Format-LMFilter -Filter $filterObject -ResourcePath $resourcePathRoot
                if ($validFilter) {
                    if ($validFilter -notlike '*deviceType%22*') {
                        $validFilter = "$validFilter,$deviceTypeCombinedClause"
                    }
                }
                else {
                    $validFilter = $deviceTypeCombinedClause
                }

                $queryParams = "?filter=$validFilter&size=$BatchSize&offset=$count&sort=+id"
            }
        }

        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'GET' -ResourcePath $resourcePath
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)$resourcePath$queryParams"

        Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation

        $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'GET' -Headers $headers[0] -WebSession $headers[1]

        if ($PSCmdlet.ParameterSetName -eq 'Id') {
            return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.LMUptimeDevice')
        }

        [Int]$total = $response.total
        [Int]$count += ($response.items | Measure-Object).Count
        $results += $response.items

        if ($count -ge $total -or $total -eq 0) {
            $done = $true
        }
    }

    return (Add-ObjectTypeInfo -InputObject $results -TypeName 'LogicMonitor.LMUptimeDevice')
}

