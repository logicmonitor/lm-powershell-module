<#
.SYNOPSIS
Pauses or unpauses alerts for Catchpoint tests.

.DESCRIPTION
Set-CPTestAlertState updates alert pause state via PATCH /v4/Tests/alert/state.
An alert can be paused for a duration with -PauseExpiration.

.PARAMETER Id
One or more Catchpoint test IDs.

.PARAMETER Status
Paused (0) or Unpaused (1).

.PARAMETER PauseExpiration
Pause duration as HH:MM when Status is Paused.

.PARAMETER Body
Full alert state payload with a tests array. Use instead of the convenience parameters.

.EXAMPLE
Set-CPTestAlertState -Id 12345 -Status Paused -PauseExpiration "01:00"

.EXAMPLE
Get-CPTests -Name "Homepage" | Set-CPTestAlertState -Status Unpaused

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
You can pipe Catchpoint.Test objects or objects with an Id property.

.OUTPUTS
Returns Catchpoint.Test.AlertState objects.
#>
function Set-CPTestAlertState {
    [CmdletBinding(DefaultParameterSetName = 'Status', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Status', ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('TestId')]
        [Int64[]]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Status')]
        [ValidateSet('Paused', 'Unpaused')]
        [String]$Status,

        [Parameter(ParameterSetName = 'Status')]
        [String]$PauseExpiration,

        [Parameter(Mandatory, ParameterSetName = 'Body')]
        $Body
    )

    begin {
        $script:SetCPTestAlertStateIds = [System.Collections.Generic.List[int64]]::new()
        $script:SetCPTestAlertStateAuthorized = Test-CPAuth -CallerPSCmdlet $PSCmdlet
        $script:SetCPTestAlertStateBody = $null
    }

    process {
        if (-not $script:SetCPTestAlertStateAuthorized) {
            return
        }

        if ($PSCmdlet.ParameterSetName -eq 'Body') {
            $script:SetCPTestAlertStateBody = $Body
            return
        }

        foreach ($testId in $Id) {
            $script:SetCPTestAlertStateIds.Add($testId)
        }
    }

    end {
        if (-not $script:SetCPTestAlertStateAuthorized) {
            return
        }

        $payload = $script:SetCPTestAlertStateBody
        if ($PSCmdlet.ParameterSetName -eq 'Status') {
            if ($script:SetCPTestAlertStateIds.Count -eq 0) {
                Write-Output @() -NoEnumerate
                return
            }

            $statusId = if ($Status -eq 'Paused') { 0 } else { 1 }
            $payload = @{
                tests = @(
                    $script:SetCPTestAlertStateIds | ForEach-Object {
                        $item = @{
                            testId = $_
                            status = @{ id = $statusId }
                        }

                        if ($PauseExpiration) {
                            $item.pauseExpiration = $PauseExpiration
                        }

                        $item
                    }
                )
            }
        }

        $target = if ($script:SetCPTestAlertStateIds.Count -gt 0) {
            "Test $($script:SetCPTestAlertStateIds -join ', ')"
        }
        else {
            'Catchpoint test alerts'
        }

        if ($PSCmdlet.ShouldProcess($target, "Set Catchpoint test alert state to $Status")) {
            return Invoke-CPApiRequest -ResourcePath '/v4/Tests/alert/state' -Method PATCH -Body $payload `
                -ItemPropertyName 'tests' -TypeName 'Catchpoint.Test.AlertState' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
        }
    }
}
