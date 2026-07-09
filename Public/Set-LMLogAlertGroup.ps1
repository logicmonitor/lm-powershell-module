<#
.SYNOPSIS
Updates a log alert group in LogicMonitor.

.DESCRIPTION
The Set-LMLogAlertGroup function modifies an existing log alert group (log pipeline) in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.

.PARAMETER Id
Specifies the ID of the log alert group to modify.

.PARAMETER Name
Specifies the current name of the log alert group.

.PARAMETER InputObject
A PSCustomObject containing the complete log alert group configuration. Must include id or name.

.PARAMETER NewName
Specifies the new name for the log alert group.

.PARAMETER Description
Specifies the description for the log alert group.

.PARAMETER Query
Specifies the query associated with the log alert group.

.PARAMETER Partitions
Specifies an array of partition names associated with the log alert group.

.EXAMPLE
Set-LMLogAlertGroup -Id 10 -Description "Updated description"

.EXAMPLE
$config = Get-LMLogAlertGroup -Id 10
$config.description = "Updated via InputObject"
Set-LMLogAlertGroup -InputObject $config

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns LogicMonitor.LogAlertGroup object.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMLogAlertGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

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
        [String]$Query,

        [Parameter(ParameterSetName = 'Id')]
        [Parameter(ParameterSetName = 'Name')]
        [Alias('Partition')]
        [String[]]$Partitions
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                if ($InputObject.id) {
                    $Id = $InputObject.id
                }
                elseif ($InputObject.name) {
                    $LookupResult = (Get-LMLogAlertGroup -Name $InputObject.name).id
                    if (Test-LookupResult -Result $LookupResult -LookupString $InputObject.name) { return }
                    $Id = $LookupResult
                }
                else {
                    Write-Error "InputObject must contain either an 'id' or 'name' property."
                    return
                }
                $ResourcePath = "/logpipelines/$Id"
                $Message = "Id: $Id | Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                if ($Name) {
                    $LookupResult = (Get-LMLogAlertGroup -Name $Name).id
                    if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                    $Id = $LookupResult
                }
                $ResourcePath = "/logpipelines/$Id"
                $Message = "Id: $Id | Name: $Name"
                $Data = @{
                    name        = $NewName
                    description = $Description
                    query       = $Query
                    partitions  = if ($PSBoundParameters.ContainsKey('Partitions')) { [string[]]@($Partitions) } else { $null }
                }
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -ConditionalKeep @{ 'name' = 'NewName' }
            }

            if ($PSCmdlet.ShouldProcess($Message, "Set Log Alert Group")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlertGroup")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
