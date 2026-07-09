<#
.SYNOPSIS
Creates a new LogicMonitor action rule.

.DESCRIPTION
The New-LMActionRule function creates a new action rule in LogicMonitor.

.PARAMETER Name
Specifies the name for the action rule.

.PARAMETER ActionChainId
Specifies the ID of the action chain to use.

.PARAMETER DeviceGroups
Specifies an array of device group full paths to apply the rule to.

.PARAMETER LevelStr
Specifies the level string for the action rule. Valid values: "All", "Critical", "Error", "Warning".

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

.PARAMETER Enabled
Specifies whether the action rule is enabled after creation.

.EXAMPLE
New-LMActionRule -Name "Disk Rule" -ActionChainId 456 -DeviceGroups @("/Servers") -LevelStr "Critical"

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.ActionRule object.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function New-LMActionRule {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory)]
        [Int]$ActionChainId,

        [Parameter(Mandatory)]
        [String[]]$DeviceGroups,

        [Parameter(Mandatory)]
        [ValidateSet("All", "Critical", "Error", "Warning")]
        [String]$LevelStr,

        [String[]]$Devices,

        [String]$DataSource,

        [Alias("DataSourceInstanceName")]
        [String]$Instance,

        [String]$DataPoint,

        [Hashtable]$ResourceProperties,

        [Boolean]$Enabled
    )

    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/setting/action/rules"

            $Data = @{
                name           = $Name
                actionChainId  = $ActionChainId
                deviceGroups   = $DeviceGroups
                levelStr       = $LevelStr
            }

            if ($Devices) { $Data.Add("devices", $Devices) }
            if ($DataSource) { $Data.Add("datasource", $DataSource) }
            if ($Instance) { $Data.Add("instance", $Instance) }
            if ($DataPoint) { $Data.Add("datapoint", $DataPoint) }
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
            $Message = "Name: $Name | ActionChainId: $ActionChainId"

            if ($PSCmdlet.ShouldProcess($Message, "Create Action Rule")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Body
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body
                $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionRule"

                if ($PSBoundParameters.ContainsKey('Enabled')) {
                    $StatusPath = "/setting/action/rules/$($Response.id)/status"
                    $StatusBody = (@{ enabled = $Enabled } | ConvertTo-Json)
                    $StatusHeaders = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $StatusPath -Data $StatusBody
                    $StatusUri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $StatusPath
                    Resolve-LMDebugInfo -Url $StatusUri -Headers $StatusHeaders[0] -Command $MyInvocation -Payload $StatusBody
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $StatusUri -Method "PATCH" -Headers $StatusHeaders[0] -WebSession $StatusHeaders[1] -Body $StatusBody
                    $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ActionRule"
                }

                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
