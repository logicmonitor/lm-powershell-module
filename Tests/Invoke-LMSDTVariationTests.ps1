<#
.SYNOPSIS
    Runs live API integration tests for all SDT schedule and resource variations.

.DESCRIPTION
    Uses the current Connect-LMAccount session ($Script:LMAuth), discovers the first available
    resource of each SDT target type, and attempts to create every schedule variation across all
    New-LM*SDT cmdlets. Optionally exercises Set-LMSDT and removes created SDTs when finished.

.PARAMETER NoCleanup
    Leave created SDTs in the portal after the run.

.PARAMETER SkipSet
    Skip Set-LMSDT update tests.

.PARAMETER PassThru
    Return test result objects instead of only writing the summary table.

.EXAMPLE
    Connect-LMAccount -UseCachedCredential
    Invoke-LMSDTVariationTests

.EXAMPLE
    Invoke-LMSDTVariationTests -NoCleanup -PassThru

.NOTES
    You must run Connect-LMAccount before running this command.

.INPUTS
    None.

.OUTPUTS
    Returns test result objects when -PassThru is specified.
#>
function Invoke-LMSDTVariationTests {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param (
        [switch]$NoCleanup,
        [switch]$SkipSet,
        [switch]$PassThru
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error 'Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again.'
        return
    }

    $script:LMSDTVariationTestSuffix = [guid]::NewGuid().ToString('N').Substring(0, 8)
    $createdSdtIds = [System.Collections.Generic.List[string]]::new()
    $results = [System.Collections.Generic.List[object]]::new()

    try {
        $resources = Get-LMSDTVariationTestResources
        $targets = Get-LMSDTVariationResourceTargets -Resources $resources
        $scenarios = Get-LMSDTVariationScheduleScenarios

        if ($targets.Count -eq 0) {
            throw 'No SDT resource targets were discovered. Cannot continue.'
        }

        Write-LMSDTVariationTestLog "Running $($targets.Count) resource type(s) x $($scenarios.Count) schedule variation(s)..." -Level Header

        $firstCreatedSdt = $null

        foreach ($target in $targets) {
            foreach ($scenario in $scenarios) {
                $testName = "$($target.Key).$($scenario.Key)"
                $testResult = Invoke-LMSDTVariationCreateTest `
                    -Name $testName `
                    -Cmdlet $target.Cmdlet `
                    -ResourceParameters $target.Resource `
                    -ScheduleParameters $scenario.Params `
                    -CreatedSdtIds $createdSdtIds

                $results.Add($testResult) | Out-Null

                if (-not $firstCreatedSdt -and $testResult.Sdt) {
                    $firstCreatedSdt = $testResult.Sdt
                }
            }
        }

        if (-not $SkipSet -and $firstCreatedSdt) {
            Write-LMSDTVariationTestLog 'Set-LMSDT update tests...' -Level Header

            foreach ($updateTest in @(
                    @{
                        Name   = 'Set.CommentOnly'
                        Params = @{ Comment = "Logic.Monitor.SDT.Test.Set.CommentOnly.$($script:LMSDTVariationTestSuffix)" }
                    },
                    @{
                        Name   = 'Set.OneTimeDuration'
                        Params = @{
                            Comment  = "Logic.Monitor.SDT.Test.Set.Duration.$($script:LMSDTVariationTestSuffix)"
                            Duration = 60
                            Timezone = 'America/New_York'
                        }
                    },
                    @{
                        Name   = 'Set.Weekly'
                        Params = @{
                            Comment     = "Logic.Monitor.SDT.Test.Set.Weekly.$($script:LMSDTVariationTestSuffix)"
                            SdtType     = 'Weekly'
                            StartHour   = 10
                            StartMinute = 0
                            EndHour     = 11
                            EndMinute   = 0
                            WeekDay     = @('Wednesday')
                            Timezone    = 'America/New_York'
                        }
                    }
                )) {
                $updateResult = Invoke-LMSDTVariationUpdateTest `
                    -Name $updateTest.Name `
                    -Id $firstCreatedSdt.Id `
                    -UpdateParameters $updateTest.Params
                $results.Add($updateResult) | Out-Null
            }
        }
        elseif (-not $SkipSet) {
            Write-LMSDTVariationTestLog 'Skipping Set-LMSDT tests because no SDT was created successfully.' -Level Warn
        }
    }
    finally {
        if (-not $NoCleanup) {
            Remove-LMSDTVariationTestSdts -CreatedSdtIds $createdSdtIds
        }
        elseif ($createdSdtIds.Count -gt 0) {
            Write-LMSDTVariationTestLog 'NoCleanup specified. Created SDT IDs:' -Level Warn
            $createdSdtIds | ForEach-Object { Write-LMSDTVariationTestLog "  $_" -Level Warn }
        }
    }

    $output = @($results | Sort-Object Name)
    $failed = @($output | Where-Object { -not $_.Success }).Count
    $passed = @($output | Where-Object Success).Count

    Write-Host ''
    Write-LMSDTVariationTestLog '=== Results ===' -Level Header
    Write-LMSDTVariationTestLog "Passed: $passed  Failed: $failed  Total: $($output.Count)" -Level $(if ($failed -eq 0) { 'Pass' } else { 'Warn' })
    $output | Format-Table Name, Success, Detail -AutoSize

    if ($PassThru) {
        return $output
    }

    if ($failed -gt 0) {
        Write-Error "$failed SDT variation test(s) failed."
    }
}
