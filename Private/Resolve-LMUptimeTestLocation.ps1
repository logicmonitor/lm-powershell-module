function Resolve-LMUptimeTestLocation {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [bool]$IsInternal,

        [Nullable[bool]]$TestLocationAll,

        [int[]]$TestLocationCollectorIds,

        [int[]]$TestLocationSmgIds,

        [bool]$AllowUnset = $false,

        [switch]$WasTestLocationAllSpecified,

        [switch]$WasCollectorIdsSpecified,

        [switch]$WasSmgIdsSpecified
    )

    $collectorSpecified = $WasCollectorIdsSpecified.IsPresent -or ($TestLocationCollectorIds -and $TestLocationCollectorIds.Count -gt 0)
    $smgSpecified = $WasSmgIdsSpecified.IsPresent -or ($TestLocationSmgIds -and $TestLocationSmgIds.Count -gt 0)

    if ($collectorSpecified -and $smgSpecified) {
        throw "TestLocationCollectorIds and TestLocationSmgIds cannot be used together."
    }

    if ($IsInternal -and $smgSpecified) {
        throw "TestLocationSmgIds is only valid for external uptime devices."
    }

    if (-not $IsInternal -and $collectorSpecified) {
        throw "TestLocationCollectorIds is only valid for internal uptime devices."
    }

    if (-not $IsInternal -and -not $smgSpecified -and -not $AllowUnset) {
        throw "TestLocationSmgIds must be specified for external uptime devices."
    }

    if ($IsInternal -and -not $collectorSpecified -and -not $AllowUnset) {
        throw "TestLocationCollectorIds is required for internal uptime devices."
    }

    if (-not $collectorSpecified -and -not $smgSpecified) {
        if ($AllowUnset) {
            return $null
        }
    }

    # Determine the 'all' flag value:
    # - If TestLocationAll was explicitly specified, use that value
    # - If SMG IDs are provided without explicit 'all', default to false (use only specified locations)
    # - If collector IDs are provided without explicit 'all', default to true (use all specified collectors)
    $allFlagValue = $true
    if ($WasTestLocationAllSpecified.IsPresent) {
        $allFlagValue = [bool]$TestLocationAll
    }
    elseif ($smgSpecified) {
        # For external checks with specific SMG IDs, default to false to respect the specific IDs
        $allFlagValue = $false
    }
    # For internal checks with collector IDs, keep default true

    # Build testLocation object
    $testLocation = @{
        collectorIds = @()
        collectors   = @()
        smgIds       = @()
        all          = $allFlagValue
    }

    if ($collectorSpecified) {
        # Ensure it's always an array, even with a single item
        if ($TestLocationCollectorIds) {
            $testLocation.collectorIds = @($TestLocationCollectorIds)
        }
        else {
            $testLocation.collectorIds = @()
        }
    }

    if ($smgSpecified) {
        # Ensure it's always an array, even with a single item
        if ($TestLocationSmgIds) {
            $testLocation.smgIds = @($TestLocationSmgIds)
        }
        else {
            $testLocation.smgIds = @()
        }
    }

    return $testLocation
}