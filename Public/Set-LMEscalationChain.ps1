<#
.SYNOPSIS
Updates a LogicMonitor escalation chain configuration.

.DESCRIPTION
The Set-LMEscalationChain function modifies an existing escalation chain in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.

.PARAMETER Id
Specifies the ID of the escalation chain to modify.

.PARAMETER Name
Specifies the current name of the escalation chain.

.PARAMETER InputObject
A PSCustomObject containing the complete escalation chain configuration. Must include id or name.

.PARAMETER NewName
Specifies the new name for the escalation chain.

.PARAMETER Description
Specifies the description for the escalation chain.

.PARAMETER Destinations
Specifies the escalation chain destinations.

.PARAMETER CcDestinations
Specifies the CC destinations for the escalation chain.

.PARAMETER EnableThrottling
Whether throttling is enabled for the chain.

.PARAMETER ThrottlingPeriod
The throttle period in minutes.

.PARAMETER ThrottlingAlerts
Maximum alerts during a throttle period.

.EXAMPLE
Set-LMEscalationChain -Id 123 -NewName "Updated Chain"

.EXAMPLE
$config = Get-LMEscalationChain -Id 123
$config.description = "Updated via InputObject"
Set-LMEscalationChain -InputObject $config

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns escalation chain object from LogicMonitor.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMEscalationChain {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$NewName,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Object[]]$Destinations,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Object[]]$CcDestinations,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Boolean]$EnableThrottling,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Int]$ThrottlingPeriod,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Int]$ThrottlingAlerts
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                if ($InputObject.id) {
                    $Id = $InputObject.id
                }
                elseif ($InputObject.name) {
                    $LookupResult = (Get-LMEscalationChain -Name $InputObject.name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $InputObject.name) { return }
                    $Id = $LookupResult
                }
                else {
                    Write-Error "InputObject must contain either an 'id' or 'name' property."
                    return
                }
                $ResourcePath = "/setting/alert/chains/$Id"
                $Message = "Id: $Id | Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 20
            }
            else {
                if ($Name) {
                    $LookupResult = (Get-LMEscalationChain -Name $Name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                    $Id = $LookupResult
                }
                $ResourcePath = "/setting/alert/chains/$Id"
                $Message = "Id: $Id | Name: $Name"
                $Data = @{
                    name             = $NewName
                    description      = $Description
                    destinations     = $Destinations
                    ccDestinations   = $CcDestinations
                    enableThrottling = $EnableThrottling
                    throttlingPeriod = $ThrottlingPeriod
                    throttlingAlerts = $ThrottlingAlerts
                }
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -ConditionalKeep @{ 'name' = 'NewName' }
            }

            if ($PSCmdlet.ShouldProcess($Message, "Set EscalationChain")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
