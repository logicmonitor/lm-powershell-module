<#
.SYNOPSIS
Creates a new log alert group in LogicMonitor.

.DESCRIPTION
The New-LMLogAlertGroup function creates a new log alert group (log pipeline) in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.

.PARAMETER InputObject
A PSCustomObject containing the complete log alert group configuration.

.PARAMETER Name
The name of the log alert group. Mandatory when using explicit parameters.

.PARAMETER Description
The description for the log alert group.

.PARAMETER Query
The query associated with the log alert group. Mandatory when using explicit parameters.

.PARAMETER Partitions
An array of partition names associated with the log alert group. Mandatory when using explicit parameters.

.EXAMPLE
New-LMLogAlertGroup -Name "Production Logs" -Query "environment:production" -Partitions @("default")

.EXAMPLE
$config = @{
    name = "Production Logs"
    query = "environment:production"
    partitions = @("default")
}
New-LMLogAlertGroup -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogAlertGroup object.
#>
function New-LMLogAlertGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Description,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Query,

        [Parameter(ParameterSetName = 'Default')]
        [Alias('Partition')]
        [String[]]$Partitions
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/logpipelines"

            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "LogAlertGroup Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                $Message = "LogAlertGroup Name: $Name"
                $Data = @{
                    name        = $Name
                    description = $Description
                    query       = $Query
                    partitions  = @($Partitions)
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -AlwaysKeepKeys @('name', 'query')
            }

            if ($PSCmdlet.ShouldProcess($Message, "New Log Alert Group")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlertGroup")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
