<#
.SYNOPSIS
Runs a new Catchpoint instant test.

.DESCRIPTION
New-CPInstantTest creates and runs an instant test via POST /v4/InstantTests.
Supply a full payload with -Body, or a URL and node IDs for a simple run.
The response contains the instant test ID and node status, not result data.
Use Get-CPInstantTest to retrieve results after the run completes.

.PARAMETER Body
Instant test payload. Accepts a hashtable, PSCustomObject, or JSON string.
Get a sample payload from Get-CPInstantTestConfiguration -Id 0.

.PARAMETER Url
Target URL for a simple instant test. Used when -Body is not supplied.

.PARAMETER NodeId
One or more node IDs to run the instant test from. Maximum of five nodes.

.PARAMETER InstantTestType
Catchpoint instant test type ID.

.PARAMETER MonitorType
Catchpoint monitor type ID.

.PARAMETER OnDemand
Run the instant test from public nodes instead of enterprise nodes.

.EXAMPLE
New-CPInstantTest -Url "https://example.com" -NodeId 1, 2

.EXAMPLE
$config = Get-CPInstantTestConfiguration -Id 0
New-CPInstantTest -Body $config.instantTest -OnDemand

.NOTES
You must run Connect-CPAccount before running this command.
An instant test can run from up to five nodes.

.INPUTS
You can pipe an instant test payload to this command.

.OUTPUTS
Returns a Catchpoint.InstantTest object.
#>
function New-CPInstantTest {
    [CmdletBinding(DefaultParameterSetName = 'Body', SupportsShouldProcess, ConfirmImpact = 'Low')]
    param(
        [Parameter(Mandatory, ParameterSetName = 'Body', ValueFromPipeline)]
        $Body,

        [Parameter(Mandatory, ParameterSetName = 'Simple')]
        [String]$Url,

        [Parameter(Mandatory, ParameterSetName = 'Simple')]
        [Int64[]]$NodeId,

        [Parameter(ParameterSetName = 'Simple')]
        [Int]$InstantTestType,

        [Parameter(ParameterSetName = 'Simple')]
        [Int]$MonitorType,

        [Switch]$OnDemand
    )

    process {
        if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $payload = $Body
        if ($PSCmdlet.ParameterSetName -eq 'Simple') {
            $payload = @{
                url      = $Url
                nodesIds = @($NodeId | ForEach-Object { @{ id = $_ } })
            }

            if ($PSBoundParameters.ContainsKey('InstantTestType')) {
                $payload.instantTestType = @{ id = $InstantTestType }
            }

            if ($PSBoundParameters.ContainsKey('MonitorType')) {
                $payload.monitorType = @{ id = $MonitorType }
            }
        }

        $query = @{}
        if ($OnDemand.IsPresent) {
            $query['onDemand'] = $true
        }

        $target = if ($payload -is [string]) { 'instant test' } elseif ($payload.url) { $payload.url } else { 'instant test' }
        if ($PSCmdlet.ShouldProcess($target, 'Run Catchpoint instant test')) {
            return Invoke-CPApiRequest -ResourcePath '/v4/InstantTests' -Method POST -QueryParameters $query -Body $payload `
                -TypeName 'Catchpoint.InstantTest' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
        }
    }
}
