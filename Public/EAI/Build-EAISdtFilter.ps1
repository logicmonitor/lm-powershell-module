<#
.SYNOPSIS
Builds a filter expression for Edwin SDT schedules.

.DESCRIPTION
Build-EAISdtFilter interactively creates a filter condition object for use with
New-EAISdt, Set-EAISdt, and other Edwin Action Service cmdlets.

The completed filter is saved to the global `$EAIFilter` variable.

.PARAMETER PassThru
Returns the filter object instead of only saving it to `$EAIFilter`.

.PARAMETER ExistingFilter
Optional current filter to keep or replace when updating a schedule.

.EXAMPLE
Build-EAISdtFilter

.EXAMPLE
$filter = Build-EAISdtFilter -PassThru
New-EAISdt -Name 'Maintenance' -Duration 60 -Filter $filter

.EXAMPLE
Build-EAISdtFilter -ExistingFilter (Get-EAISdt -Id $id).filter

.NOTES
Use Connect-EAIAccount before running Edwin cmdlets that submit the filter.
Requires sdt_read scope to load field metadata from the API when available.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns an Edwin filter object when using -PassThru.
#>
function Build-EAISdtFilter {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the interactive wizard')]
    param (
        [Switch]$PassThru,

        $ExistingFilter
    )

    try {
        Write-Host ''
        Write-Host 'Welcome to the Edwin SDT Filter Builder!'
        Write-Host 'Build a filter to choose which events a schedule suppresses.'
        Write-Host 'Filters use schemaName filterCondition, schemaVersion 4, and a JSON expression tree.'
        Write-Host ''

        $filter = $null

        if ($ExistingFilter) {
            Write-Host '--- Current Filter ---' -ForegroundColor Cyan
            Write-EAISdtFilterPreview -Filter $ExistingFilter
            Write-Host '----------------------'

            if (Get-LMUserConfirmation -Prompt 'Keep the current filter?' -DefaultAnswer 'y') {
                $filter = ConvertTo-EAISdtFilterObject -Filter $ExistingFilter
            }
        }

        if (-not $filter) {
            $expression = Read-EAISdtFilterExpressionInteractive
            $filter = New-EAISdtFilterObject -Expression $expression
        }

        Test-EAISdtFilterObject -Filter $filter | Out-Null

        Write-Host ''
        Write-Host '--- Filter Preview ---' -ForegroundColor Cyan
        Write-EAISdtFilterPreview -Filter $filter
        Write-Host '----------------------'

        if (-not (Get-LMUserConfirmation -Prompt 'Use this filter?' -DefaultAnswer 'y')) {
            Write-Host 'Filter builder cancelled.' -ForegroundColor Yellow
            return $null
        }

        Set-Variable -Name 'EAIFilter' -Value $filter -Scope Global

        if (-not $PassThru) {
            Write-Host 'Filter has been saved to the `$EAIFilter variable.' -ForegroundColor Green
            return
        }

        Write-Host 'Filter has been saved to the `$EAIFilter variable.' -ForegroundColor Green
        return $filter
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}
