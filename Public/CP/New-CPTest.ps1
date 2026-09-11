<#
.SYNOPSIS
Creates a Catchpoint test.

.DESCRIPTION
New-CPTest creates a test via POST /v4/Tests. Supply the full test payload
returned by Get-CPTests -Id 0 or an existing test object.

.PARAMETER Body
Test payload. Accepts a hashtable, PSCustomObject, or JSON string.

.PARAMETER ObjectDetails
Return the created test object instead of only the created object ID.

.EXAMPLE
$template = Get-CPTests -Id 0
$template.name = "Homepage"
New-CPTest -Body $template -ObjectDetails

.NOTES
You must run Connect-CPAccount before running this command.
Test Type, Test ID, and Division ID cannot be changed after creation.

.INPUTS
You can pipe a test payload to this command.

.OUTPUTS
Returns a Catchpoint.Test object.
#>
function New-CPTest {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $Body,

        [Switch]$ObjectDetails
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $query = @{}
        if ($ObjectDetails.IsPresent) {
            $query['objectDetails'] = $true
        }

        $target = if ($Body -is [string]) { 'Catchpoint test' } elseif ($Body.name) { $Body.name } else { 'Catchpoint test' }
        if ($PSCmdlet.ShouldProcess($target, 'Create Catchpoint test')) {
            return Invoke-CPApiRequest -ResourcePath '/v4/Tests' -Method POST -QueryParameters $query -Body $Body `
                -TypeName 'Catchpoint.Test' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
        }
    }
}
