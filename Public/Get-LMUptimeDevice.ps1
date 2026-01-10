<#
.SYNOPSIS
Retrieves LogicMonitor Uptime devices from the v3 device endpoint.

.DESCRIPTION
The Get-LMUptimeDevice cmdlet returns Uptime monitors (web or ping) that are backed by the
LogicMonitor v3 /device/devices endpoint. It supports lookup by ID or name, optional filtering
by internal/external flag, custom filters, and the interactive filter wizard. The Type parameter
is mandatory and determines whether to retrieve webcheck or pingcheck uptime devices, returning
the full response structure specific to that type.

.PARAMETER Id
Specifies the identifier of the Uptime device to retrieve.

.PARAMETER Name
Specifies the name of the Uptime device to retrieve.

.PARAMETER Type
Specifies the Uptime monitor type to retrieve. This parameter is mandatory and determines the
response structure. Valid values are uptimewebcheck and uptimepingcheck.

.PARAMETER IsInternal
Filters results by internal (true) or external (false) monitors.

.PARAMETER Filter
Provides a filter object for advanced queries.

.PARAMETER FilterWizard
Launches the interactive filter wizard and applies the chosen filter.

.PARAMETER BatchSize
Controls the number of results returned per request. Must be between 1 and 1000. Default 1000.

.EXAMPLE
Get-LMUptimeDevice -Type uptimewebcheck

Retrieves all web Uptime devices across the account.

.EXAMPLE
Get-LMUptimeDevice -Type uptimewebcheck -IsInternal $true

Retrieves internal web Uptime devices only.

.EXAMPLE
Get-LMUptimeDevice -Name "web-int-01" -Type uptimewebcheck

Retrieves a specific web Uptime device by name.

.EXAMPLE
Get-LMUptimeDevice -Id 123 -Type uptimepingcheck

Retrieves a specific ping Uptime device by ID.

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

        [Parameter(Mandatory)]
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

    $queryParams = ''
    $count = 0
    $done = $false
    $results = @()

    while (-not $done) {
        $resourcePath = $resourcePathRoot
        $queryParams = ''

        switch ($PSCmdlet.ParameterSetName) {
            'All' {
                $filterParts = @()

                if ($PSBoundParameters.ContainsKey('IsInternal')) {
                    $boolValue = ([bool]$IsInternal).ToString().ToLowerInvariant()
                    $filterParts += "isInternal:$boolValue"
                }

                $filterString = $filterParts -join ','
                if ($filterString) {
                    $queryParams = "?filter=$filterString&size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
                else {
                    $queryParams = "?size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
            }
            'Id' {
                $resourcePath = "$resourcePath/$Id"
                $queryParams = "?type=$Type"
            }
            'Name' {
                $filterString = "name:%22$Name%22"
                $queryParams = "?filter=$filterString&size=$BatchSize&offset=$count&sort=+id&type=$Type"
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
                    $queryParams = "?filter=$validFilter&size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
                else {
                    $queryParams = "?size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
            }
            'FilterWizard' {
                $filterObject = Build-LMFilter -PassThru -ResourcePath $resourcePathRoot
                if (-not $filterObject) {
                    return
                }
                $validFilter = Format-LMFilter -Filter $filterObject -ResourcePath $resourcePathRoot
                if ($validFilter) {
                    $queryParams = "?filter=$validFilter&size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
                else {
                    $queryParams = "?size=$BatchSize&offset=$count&sort=+id&type=$Type"
                }
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

