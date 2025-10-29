<#
.SYNOPSIS
Retrieves recently deleted resources from the LogicMonitor recycle bin.

.DESCRIPTION
The Get-LMRecentlyDeleted function queries the LogicMonitor recycle bin for deleted resources
within a configurable time range. Results can be filtered by resource type and deleted-by user,
and support paging through the API using size, offset, and sort parameters.

.PARAMETER ResourceType
Limits results to a specific resource type. Accepted values are All, device, and deviceGroup.
Defaults to All.

.PARAMETER DeletedAfter
The earliest deletion timestamp (inclusive) to return. Defaults to seven days prior when not specified.

.PARAMETER DeletedBefore
The latest deletion timestamp (exclusive) to return. Defaults to the current time when not specified.

.PARAMETER DeletedBy
Limits results to items deleted by the specified user principal.

.PARAMETER BatchSize
The number of records to request per API call (1-1000). Defaults to 1000.

.PARAMETER Sort
Sort expression passed to the API. Defaults to -deletedOn.

.EXAMPLE
Get-LMRecentlyDeleted -ResourceType device -DeletedBy "lmsupport"

Retrieves every device deleted by the user lmsupport over the past seven days.

.EXAMPLE
Get-LMRecentlyDeleted -DeletedAfter (Get-Date).AddDays(-1) -DeletedBefore (Get-Date) -BatchSize 100 -Sort "+deletedOn"

Retrieves deleted resources from the past 24 hours in ascending order of deletion time.

.NOTES
You must establish a session with Connect-LMAccount prior to calling this function.
#>
function Get-LMRecentlyDeleted {

    [CmdletBinding()]
    param (
        [ValidateSet('All', 'device', 'deviceGroup')]
        [String]$ResourceType = 'All',

        [Nullable[DateTime]]$DeletedAfter,

        [Nullable[DateTime]]$DeletedBefore,

        [String]$DeletedBy,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000,

        [String]$Sort = '-deletedOn'
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    function Get-EpochMilliseconds {
        param ([Parameter(Mandatory)][DateTime]$InputDate)
        return [long][Math]::Round((New-TimeSpan -Start (Get-Date -Date '1/1/1970') -End $InputDate.ToUniversalTime()).TotalMilliseconds)
    }

    $now = Get-Date

    if (-not $DeletedAfter -and -not $DeletedBefore) {
        $DeletedBefore = $now
        $DeletedAfter = $now.AddDays(-7)
    }
    else {
        if (-not $DeletedAfter) {
            $DeletedAfter = $now.AddDays(-7)
        }
        if (-not $DeletedBefore) {
            $DeletedBefore = $now
        }
    }

    if ($DeletedAfter -and $DeletedBefore -and $DeletedAfter -gt $DeletedBefore) {
        Write-Error "The value supplied for DeletedAfter occurs after DeletedBefore. Please adjust the time range and try again."
        return
    }

    $filterParts = @()

    if ($DeletedAfter) {
        $filterParts += ('deletedOn>:"{0}"' -f (Get-EpochMilliseconds -InputDate $DeletedAfter))
    }

    if ($DeletedBefore) {
        $filterParts += ('deletedOn<:"{0}"' -f (Get-EpochMilliseconds -InputDate $DeletedBefore))
    }

    if ($ResourceType -ne 'All') {
        $filterParts += ('resourceType:"{0}"' -f $ResourceType)
    }

    if ($DeletedBy) {
        $filterParts += ('deletedBy:"{0}"' -f $DeletedBy)
    }

    $filterString = $null
    if ($filterParts.Count -gt 0) {
        $filterString = $filterParts -join ','
    }

    $resourcePath = '/recyclebin/recycles'
    $results = @()
    $currentOffset = 0
    $total = $null

    while ($true) {
        $queryParams = "?size=$BatchSize&offset=$currentOffset&sort=$Sort"
        if ($filterString) {
            $queryParams += "&filter=$filterString"
        }

        $headers = New-LMHeader -Auth $Script:LMAuth -Method 'GET' -ResourcePath $resourcePath
        $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $resourcePath + $queryParams

        Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation

        $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'GET' -Headers $headers[0] -WebSession $headers[1]

        $itemCount = 0
        if ($response.items) {
            $results += $response.items
            $itemCount = ($response.items | Measure-Object).Count
        }

        if (-not $total -and $response.total) {
            $total = $response.total
        }

        if ($itemCount -lt $BatchSize) {
            break
        }

        if ($total -and (($currentOffset + $itemCount) -ge $total)) {
            break
        }

        $currentOffset += $itemCount
    }

    if ($response.total) {
        Write-Verbose "Retrieved $($results.Count) of $($response.total) recently deleted items."
    }
    else {
        Write-Verbose "Retrieved $($results.Count) recently deleted items."
    }

    return (Add-ObjectTypeInfo -InputObject $results -TypeName 'LogicMonitor.RecentlyDeleted')
}

