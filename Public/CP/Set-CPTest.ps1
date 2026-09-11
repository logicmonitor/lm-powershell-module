<#
.SYNOPSIS
Updates a Catchpoint test property.

.DESCRIPTION
Set-CPTest applies a JSON Patch to an existing test via PATCH /v4/Tests/{id}.
Only the properties being changed should be sent. Test Type, Test ID, and
Division ID cannot be updated. Changing Product ID or Folder ID moves the test.

.PARAMETER Id
Test ID to update.

.PARAMETER Operation
JSON Patch operation: Add, Remove, or Replace.

.PARAMETER Path
JSON Pointer path of the property to update, for example /status/id.

.PARAMETER Value
New value for Add or Replace operations.

.PARAMETER Patch
One or more JSON Patch operations as hashtables or objects with op, path, and value.

.PARAMETER ObjectDetails
Return the updated test object instead of only the updated object ID.

.EXAMPLE
Set-CPTest -Id 12345 -Operation Replace -Path "/status/id" -Value 1

.EXAMPLE
Set-CPTest -Id 12345 -Patch @(
    @{ op = 'replace'; path = '/name'; value = 'Homepage' }
)

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
You can pipe Catchpoint.Test objects or objects with an Id property.

.OUTPUTS
Returns a Catchpoint.Test object.
#>
function Set-CPTest {
    [CmdletBinding(DefaultParameterSetName = 'Operation', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Int64]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Operation')]
        [ValidateSet('Add', 'Remove', 'Replace')]
        [String]$Operation,

        [Parameter(Mandatory, ParameterSetName = 'Operation')]
        [String]$Path,

        [Parameter(ParameterSetName = 'Operation')]
        $Value,

        [Parameter(Mandatory, ParameterSetName = 'Patch')]
        [Object[]]$Patch,

        [Switch]$ObjectDetails
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $operations = @()
        if ($PSCmdlet.ParameterSetName -eq 'Patch') {
            $operations = @($Patch)
        }
        else {
            $op = switch ($Operation) {
                'Add' { 'add' }
                'Remove' { 'Remove' }
                'Replace' { 'replace' }
            }

            $item = @{
                op   = $op
                path = $Path
            }

            if ($PSBoundParameters.ContainsKey('Value')) {
                $item.value = $Value
            }

            $operations = @($item)
        }

        $query = @{}
        if ($ObjectDetails.IsPresent) {
            $query['objectDetails'] = $true
        }

        if ($PSCmdlet.ShouldProcess("Test $Id", 'Update Catchpoint test')) {
            return Invoke-CPApiRequest -ResourcePath "/v4/Tests/$Id" -Method PATCH -QueryParameters $query -Body $operations `
                -TypeName 'Catchpoint.Test' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
        }
    }
}
