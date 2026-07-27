<#
.SYNOPSIS
Builds a filter expression for Edwin record queries.

.DESCRIPTION
Build-EAIQueryFilter interactively creates a filterCondition schema version 4 object for use with
Invoke-EAIRecordsQuery and other Edwin UI Query cmdlets.

The completed filter is saved to the global `$EAIQueryFilter` variable. The same filter DSL is used
for SDT schedules and record queries.

.PARAMETER PassThru
Returns the filter object instead of only saving it to `$EAIQueryFilter`.

.PARAMETER ExistingFilter
Optional current filter to keep or replace when refining a query.

.EXAMPLE
Build-EAIQueryFilter

.EXAMPLE
$filter = Build-EAIQueryFilter -PassThru
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName' -Filter $filter

.EXAMPLE
Build-EAIQueryFilter -ExistingFilter $filter

.NOTES
Use Connect-EAIAccount before running Edwin query cmdlets.
Requires query_records scope on the credentials used for Invoke-EAIRecordsQuery.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns an Edwin filter object when using -PassThru.
#>
function Build-EAIQueryFilter {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for the interactive wizard')]
    param (
        [Switch]$PassThru,

        $ExistingFilter
    )

    try {
        Write-Host ''
        Write-Host 'Welcome to the Edwin Query Filter Builder!'
        Write-Host 'Build a filter to choose which records match your search.'
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

        Set-Variable -Name 'EAIQueryFilter' -Value $filter -Scope Global

        if (-not $PassThru) {
            Write-Host 'Filter has been saved to the `$EAIQueryFilter variable.' -ForegroundColor Green
            return
        }

        Write-Host 'Filter has been saved to the `$EAIQueryFilter variable.' -ForegroundColor Green
        return $filter
    }
    catch [LMSDTWizardCancelledException] {
        Write-Host $_.Exception.Message -ForegroundColor Yellow
        return $null
    }
}
