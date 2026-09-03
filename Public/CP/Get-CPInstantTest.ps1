<#
.SYNOPSIS
Retrieves Catchpoint instant test results.

.DESCRIPTION
Get-CPInstantTest returns performance data for an instant test via
GET /v4/InstantTests/{id}. Results are for one node and a single step.
If -StepId is omitted, the first step is returned.

.PARAMETER Id
Instant test ID.

.PARAMETER NodeId
Node ID to retrieve results for.

.PARAMETER StepId
Step ID for multi-step transaction tests. Defaults to 0 (first step).

.EXAMPLE
Get-CPInstantTest -Id 12345 -NodeId 17

.EXAMPLE
$run = New-CPInstantTest -Url "https://example.com" -NodeId 17
Get-CPInstantTest -Id $run.id -NodeId 17

.NOTES
You must run Connect-CPAccount before running this command.
This is an analytics endpoint and counts against Catchpoint usage limits.

.INPUTS
You can pipe objects with an Id property to this command.

.OUTPUTS
Returns a Catchpoint.InstantTest.Result object.
#>
function Get-CPInstantTest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('InstantTestId')]
        [Int64]$Id,

        [Parameter(Mandatory)]
        [Int]$NodeId,

        [Int]$StepId = 0
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $query = @{
            nodeId = $NodeId
            stepId = $StepId
        }

        return Invoke-CPApiRequest -ResourcePath "/v4/InstantTests/$Id" -Method GET -QueryParameters $query `
            -TypeName 'Catchpoint.InstantTest.Result' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
    }
}
