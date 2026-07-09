<#
.SYNOPSIS
Creates a new LogicMonitor action chain.

.DESCRIPTION
The New-LMActionChain function creates a new action chain in LogicMonitor. You can
specify individual parameters or provide a complete configuration object using the InputObject parameter.

.PARAMETER InputObject
A PSCustomObject containing the complete action chain configuration.

.PARAMETER Name
The name of the action chain. Mandatory when using explicit parameters.

.PARAMETER Stages
The ordered list of action chain stages. Each stage requires id and type
(diagnosticSource or remediationSource).

.PARAMETER Description
The description for the action chain.

.EXAMPLE
New-LMActionChain -Name "Disk Chain" -Stages @(
    @{ id = 123; type = 'diagnosticSource' },
    @{ id = 456; type = 'remediationSource' }
)

.EXAMPLE
$config = @{
    name = "Disk Chain"
    stages = @(
        @{ id = 123; type = 'diagnosticSource' }
    )
}
New-LMActionChain -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ActionChain object.
#>
function New-LMActionChain {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [PSCustomObject[]]$Stages,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Description
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/action/chains"

            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "ActionChain Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                $Message = "ActionChain Name: $Name"
                $Data = @{
                    name        = $Name
                    stages      = $Stages
                    description = $Description
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys
            }

            if ($PSCmdlet.ShouldProcess($Message, "New ActionChain")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionChain")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
