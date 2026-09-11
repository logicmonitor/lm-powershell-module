<#
.SYNOPSIS
Retrieves Catchpoint test alert pause state.

.DESCRIPTION
Get-CPTestAlertState returns whether alerts are paused or unpaused for one or
more tests via GET /v4/Tests/alert/state/{testIds}.

.PARAMETER Id
One or more Catchpoint test IDs.

.EXAMPLE
Get-CPTestAlertState -Id 12345, 67890

.EXAMPLE
Get-CPTests -Name "Homepage" | Get-CPTestAlertState

.NOTES
You must run Connect-CPAccount before running this command.
Status ID 0 is Paused and 1 is Unpaused.

.INPUTS
You can pipe Catchpoint.Test objects or objects with an Id property.

.OUTPUTS
Returns Catchpoint.Test.AlertState objects.
#>
function Get-CPTestAlertState {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('TestId')]
        [Int64[]]$Id
    )

    begin {
        $script:GetCPTestAlertStateIds = [System.Collections.Generic.List[int64]]::new()
        $script:GetCPTestAlertStateAuthorized = Test-CPAuth -CallerPSCmdlet $PSCmdlet
    }

    process {
        if (-not $script:GetCPTestAlertStateAuthorized) {
            return
        }

        foreach ($testId in $Id) {
            $script:GetCPTestAlertStateIds.Add($testId)
        }
    }

    end {
        if (-not $script:GetCPTestAlertStateAuthorized) {
            return
        }

        if ($script:GetCPTestAlertStateIds.Count -eq 0) {
            Write-Output @() -NoEnumerate
            return
        }

        $testIds = ($script:GetCPTestAlertStateIds | ForEach-Object { [string]$_ }) -join ','
        return Invoke-CPApiRequest -ResourcePath "/v4/Tests/alert/state/$testIds" -Method GET `
            -ItemPropertyName 'tests' -TypeName 'Catchpoint.Test.AlertState' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
    }
}
