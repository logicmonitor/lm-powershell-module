<#
.SYNOPSIS
Creates a new LogicMonitor escalation chain.

.DESCRIPTION
The New-LMEscalationChain function creates a new escalation chain in LogicMonitor.
Use InputObject for full chain configuration including destinations and ccDestinations.

.PARAMETER InputObject
A PSCustomObject containing the complete escalation chain configuration.

.PARAMETER Name
The name of the escalation chain. Mandatory when using explicit parameters.

.PARAMETER Destinations
The escalation chain destinations. Mandatory when using explicit parameters.

.PARAMETER Description
The description for the escalation chain.

.PARAMETER CcDestinations
The CC destinations for the escalation chain.

.PARAMETER EnableThrottling
Whether throttling is enabled for the chain.

.PARAMETER ThrottlingPeriod
The throttle period in minutes.

.PARAMETER ThrottlingAlerts
Maximum alerts during a throttle period.

.EXAMPLE
$config = @{
    name = "Critical Chain"
    destinations = @(
        @{
            type = "timebased"
            stages = @(
                @(@{ type = "user"; addr = "admin@example.com"; method = "email" })
            )
        }
    )
}
New-LMEscalationChain -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns escalation chain object from LogicMonitor.
#>
function New-LMEscalationChain {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Object[]]$Destinations,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [Object[]]$CcDestinations,

        [Parameter(ParameterSetName = 'Default')]
        [Boolean]$EnableThrottling,

        [Parameter(ParameterSetName = 'Default')]
        [Int]$ThrottlingPeriod,

        [Parameter(ParameterSetName = 'Default')]
        [Int]$ThrottlingAlerts
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/alert/chains"

            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "EscalationChain Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 20
            }
            else {
                $Message = "EscalationChain Name: $Name"
                $Data = @{
                    name             = $Name
                    destinations     = $Destinations
                    description      = $Description
                    ccDestinations   = $CcDestinations
                    enableThrottling = $EnableThrottling
                    throttlingPeriod = $ThrottlingPeriod
                    throttlingAlerts = $ThrottlingAlerts
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys
            }

            if ($PSCmdlet.ShouldProcess($Message, "New EscalationChain")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
