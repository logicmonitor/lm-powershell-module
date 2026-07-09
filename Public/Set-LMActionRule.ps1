<#
.SYNOPSIS
Updates a LogicMonitor action rule configuration.

.DESCRIPTION
The Set-LMActionRule function modifies an existing action rule in LogicMonitor.
When -Enabled is specified, the status sub-endpoint is updated separately.

.PARAMETER Id
Specifies the ID of the action rule to modify.

.PARAMETER Name
Specifies the current name of the action rule.

.PARAMETER NewName
Specifies the new name for the action rule.

.PARAMETER ActionChainId
Specifies the ID of the action chain to use.

.PARAMETER DeviceGroups
Specifies an array of device group full paths to apply the rule to.

.PARAMETER Devices
Specifies an array of device display names to apply the rule to.

.PARAMETER DataSource
Specifies the datasource name to apply the rule to.

.PARAMETER Instance
Specifies the instance name to apply the rule to.

.PARAMETER DataPoint
Specifies the datapoint name to apply the rule to.

.PARAMETER ResourceProperties
Specifies resource properties to filter on.

.PARAMETER LevelStr
Specifies the level string for the action rule. Valid values: "All", "Critical", "Error", "Warning".

.PARAMETER Enabled
Specifies whether the action rule is enabled.

.EXAMPLE
Set-LMActionRule -Id 123 -NewName "Updated Rule" -ActionChainId 456

.EXAMPLE
Set-LMActionRule -Name "Disk Rule" -Enabled $false

.INPUTS
You can pipe action rule objects containing Id properties to this function.

.OUTPUTS
Returns LogicMonitor.ActionRule object.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMActionRule {
    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [Int]$ActionChainId,

        [String[]]$DeviceGroups,

        [String[]]$Devices,

        [String]$DataSource,

        [Alias("DataSourceInstanceName")]
        [String]$Instance,

        [String]$DataPoint,

        [Hashtable]$ResourceProperties,

        [ValidateSet("All", "Critical", "Error", "Warning")]
        [String]$LevelStr,

        [Boolean]$Enabled
    )

    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            if ($Name) {
                $ActionRule = Get-LMActionRule -Name $Name
                if (Test-LookupResult -Result $ActionRule -LookupString $Name) {
                    return
                }
                $Id = $ActionRule.Id
            }

            $Response = $null
            $ConfigKeys = @(
                'NewName', 'ActionChainId', 'DeviceGroups', 'Devices', 'DataSource',
                'Instance', 'DataPoint', 'ResourceProperties', 'LevelStr'
            )
            $HasConfigUpdate = $false
            foreach ($key in $ConfigKeys) {
                if ($PSBoundParameters.ContainsKey($key)) {
                    $HasConfigUpdate = $true
                    break
                }
            }

            if ($HasConfigUpdate) {
                $ResourcePath = "/setting/action/rules/$Id"
                $Data = @{}

                if ($NewName) { $Data.Add("name", $NewName) }
                if ($PSBoundParameters.ContainsKey('ActionChainId')) { $Data.Add("actionChainId", $ActionChainId) }
                if ($DeviceGroups) { $Data.Add("deviceGroups", $DeviceGroups) }
                if ($Devices) { $Data.Add("devices", $Devices) }
                if ($DataSource) { $Data.Add("datasource", $DataSource) }
                if ($Instance) { $Data.Add("instance", $Instance) }
                if ($DataPoint) { $Data.Add("datapoint", $DataPoint) }
                if ($LevelStr) { $Data.Add("levelStr", $LevelStr) }
                if ($ResourceProperties) {
                    $ResourcePropertiesArray = @()
                    foreach ($key in $ResourceProperties.Keys) {
                        $ResourcePropertiesArray += @{
                            name  = $key
                            value = $ResourceProperties[$key]
                        }
                    }
                    $Data.Add("resourceProperties", $ResourcePropertiesArray)
                }

                $Body = ($Data | ConvertTo-Json -Depth 10)

                if ($PSItem) {
                    $Message = "Id: $Id | Name: $($PSItem.name)"
                }
                else {
                    $Message = "Id: $Id"
                }

                if ($PSCmdlet.ShouldProcess($Message, "Set Action Rule")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Body
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body
                    $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionRule"
                }
            }

            if ($PSBoundParameters.ContainsKey('Enabled')) {
                $StatusPath = "/setting/action/rules/$Id/status"
                $StatusBody = (@{ enabled = $Enabled } | ConvertTo-Json)
                $StatusMessage = "Id: $Id | Enabled: $Enabled"

                if ($PSCmdlet.ShouldProcess($StatusMessage, "Set Action Rule Status")) {
                    $StatusHeaders = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $StatusPath -Data $StatusBody
                    $StatusUri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $StatusPath
                    Resolve-LMDebugInfo -Url $StatusUri -Headers $StatusHeaders[0] -Command $MyInvocation -Payload $StatusBody
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $StatusUri -Method "PATCH" -Headers $StatusHeaders[0] -WebSession $StatusHeaders[1] -Body $StatusBody
                    $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionRule"
                }
            }

            return $Response
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
