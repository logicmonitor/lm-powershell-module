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
    $allSpecified = $WasTestLocationAllSpecified.IsPresent -or $TestLocationAll

    if ($collectorSpecified -and $smgSpecified) {
        throw "TestLocationCollectorIds and TestLocationSmgIds cannot be used together."
    }

    if ($allSpecified -and ($collectorSpecified -or $smgSpecified)) {
        throw "TestLocationAll cannot be combined with TestLocationCollectorIds or TestLocationSmgIds."
    }

    if ($IsInternal -and $smgSpecified) {
        throw "TestLocationSmgIds is only valid for external uptime devices."
    }

    if (-not $IsInternal -and $collectorSpecified) {
        throw "TestLocationCollectorIds is only valid for internal uptime devices."
    }

    if (-not $IsInternal -and $allSpecified -and $TestLocationAll -eq $false -and -not $AllowUnset) {
        throw "TestLocationAll must be specified as true when provided for external uptime devices."
    }

    if (-not $IsInternal -and $TestLocationAll -ne $true -and -not $smgSpecified -and -not $AllowUnset) {
        throw "At least one of TestLocationAll or TestLocationSmgIds must be specified for external uptime devices."
    }

    if ($IsInternal -and -not $collectorSpecified -and -not $AllowUnset) {
        throw "TestLocationCollectorIds is required for internal uptime devices."
    }

    if (-not $collectorSpecified -and -not $smgSpecified -and -not $allSpecified) {
        if ($AllowUnset) {
            return $null
        }
    }

    $testLocation = @{
        collectorIds = @()
        collectors   = @()
        smgIds       = @()
        all          = $false
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

    if ($allSpecified) {
        $testLocation.all = [bool]$TestLocationAll
    }

    return $testLocation
}