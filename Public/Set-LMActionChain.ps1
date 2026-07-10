<#
.SYNOPSIS
Updates a LogicMonitor action chain configuration.

.DESCRIPTION
The Set-LMActionChain function modifies an existing action chain in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.

.PARAMETER Id
Specifies the ID of the action chain to modify.

.PARAMETER Name
Specifies the current name of the action chain.

.PARAMETER InputObject
A PSCustomObject containing the complete action chain configuration. Must include id or name.

.PARAMETER NewName
Specifies the new name for the action chain.

.PARAMETER Description
Specifies the description for the action chain.

.PARAMETER Stages
Specifies the ordered list of action chain stages.

.EXAMPLE
Set-LMActionChain -Id 123 -NewName "Updated Chain" -Description "Updated description"

.EXAMPLE
$config = Get-LMActionChain -Id 123
$config.description = "Updated via InputObject"
Set-LMActionChain -InputObject $config

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.ActionChain object.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMActionChain {
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
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
        [PSCustomObject[]]$Stages
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                if ($InputObject.id) {
                    $Id = $InputObject.id
                }
                elseif ($InputObject.name) {
                    $LookupResult = (Get-LMActionChain -Name $InputObject.name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $InputObject.name) { return }
                    $Id = $LookupResult
                }
                else {
                    Write-Error "InputObject must contain either an 'id' or 'name' property."
                    return
                }
                $ResourcePath = "/setting/action/chains/$Id"
                $Message = "Id: $Id | Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                if ($Name) {
                    $LookupResult = (Get-LMActionChain -Name $Name).Id
                    if (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                    $Id = $LookupResult
                }
                $ResourcePath = "/setting/action/chains/$Id"
                $Message = "Id: $Id | Name: $Name"
                $Data = @{
                    name        = $NewName
                    description = $Description
                    stages      = $Stages
                }
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -ConditionalKeep @{ 'name' = 'NewName' }
            }

            if ($PSCmdlet.ShouldProcess($Message, "Set ActionChain")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionChain")
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
