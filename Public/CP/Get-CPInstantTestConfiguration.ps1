<#
.SYNOPSIS
Retrieves Catchpoint instant test configuration.

.DESCRIPTION
Get-CPInstantTestConfiguration returns the properties used to create an instant
test via GET /v4/InstantTests/configuration/{id}. Pass -Id 0 to get a sample
payload for New-CPInstantTest.

.PARAMETER Id
Instant test ID. Pass 0 to return post data for creating a new instant test.

.EXAMPLE
Get-CPInstantTestConfiguration -Id 0

.EXAMPLE
Get-CPInstantTestConfiguration -Id 12345

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
You can pipe objects with an Id property to this command.

.OUTPUTS
Returns a Catchpoint.InstantTest.Configuration object.
#>
function Get-CPInstantTestConfiguration {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('InstantTestId')]
        [Int64]$Id
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        return Invoke-CPApiRequest -ResourcePath "/v4/InstantTests/configuration/$Id" -Method GET `
            -TypeName 'Catchpoint.InstantTest.Configuration' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
    }
}
