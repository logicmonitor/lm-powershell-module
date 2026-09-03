<#
.SYNOPSIS
Runs an instant test from an existing Catchpoint test.

.DESCRIPTION
Invoke-CPInstantTest runs an existing scheduled test as an instant test via
POST /v4/InstantTests/{testId}. The response contains the instant test ID and
node status, not result data. Use Get-CPInstantTest to retrieve results.

.PARAMETER TestId
Existing Catchpoint test ID to run as an instant test.

.PARAMETER NodeId
One or more node IDs to run from. Maximum of five nodes.

.PARAMETER TokenId
Optional token IDs to include in the request.

.PARAMETER UserName
Optional authentication user name.

.PARAMETER Password
Optional authentication password.

.PARAMETER Body
Full InstantTestPostRequest payload. Use instead of the convenience parameters.

.PARAMETER OnDemand
Run the instant test from public nodes instead of enterprise nodes.

.EXAMPLE
Invoke-CPInstantTest -TestId 12345 -NodeId 17, 22

.EXAMPLE
Get-CPTests -Id 12345 | Invoke-CPInstantTest -NodeId 17 -OnDemand

.NOTES
You must run Connect-CPAccount before running this command.
An instant test can run from up to five nodes.

.INPUTS
You can pipe Catchpoint.Test objects or objects with a TestId or Id property.

.OUTPUTS
Returns a Catchpoint.InstantTest object.
#>
function Invoke-CPInstantTest {
    [CmdletBinding(DefaultParameterSetName = 'Nodes', SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias('Id')]
        [Int64]$TestId,

        [Parameter(Mandatory, ParameterSetName = 'Nodes')]
        [Int64[]]$NodeId,

        [Parameter(ParameterSetName = 'Nodes')]
        [Int[]]$TokenId,

        [Parameter(ParameterSetName = 'Nodes')]
        [String]$UserName,

        [Parameter(ParameterSetName = 'Nodes')]
        [String]$Password,

        [Parameter(Mandatory, ParameterSetName = 'Body')]
        $Body,

        [Switch]$OnDemand
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $payload = $Body
        if ($PSCmdlet.ParameterSetName -eq 'Nodes') {
            $payload = @{
                nodesIds = @($NodeId | ForEach-Object { @{ id = $_ } })
            }

            if ($TokenId) {
                $payload.tokenIds = @($TokenId)
            }

            if ($UserName -or $Password) {
                $payload.authentication = @{}
                if ($UserName) { $payload.authentication.userName = $UserName }
                if ($Password) { $payload.authentication.password = $Password }
            }
        }

        $query = @{}
        if ($OnDemand.IsPresent) {
            $query['onDemand'] = $true
        }

        if ($PSCmdlet.ShouldProcess("Test $TestId", 'Run Catchpoint instant test')) {
            return Invoke-CPApiRequest -ResourcePath "/v4/InstantTests/$TestId" -Method POST -QueryParameters $query -Body $payload `
                -TypeName 'Catchpoint.InstantTest' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
        }
    }
}
