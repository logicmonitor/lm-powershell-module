<#
.SYNOPSIS
Updates a LogicMonitor alert rule configuration.

.DESCRIPTION
The Set-LMAlertRule function modifies an existing alert rule in LogicMonitor.

.PARAMETER Id
Specifies the ID of the alert rule to modify.

.PARAMETER Name
Specifies the name for the alert rule.

.PARAMETER Priority
Specifies the priority level for the alert rule. Valid values: "High", "Medium", "Low".

.PARAMETER EscalatingChainId
Specifies the ID of the escalation chain to use.

.PARAMETER EscalationInterval
Specifies the escalation interval in minutes.

.PARAMETER ResourceProperties
Specifies resource properties to filter on.

.PARAMETER Devices
Specifies an array of device display names to apply the rule to.

.PARAMETER DeviceGroups
Specifies an array of device group full paths to apply the rule to.

.PARAMETER DataSource
Specifies the datasource name to apply the rule to.

.PARAMETER DataSourceInstanceName
Specifies the instance name to apply the rule to.

.PARAMETER DataPoint
Specifies the datapoint name to apply the rule to.

.PARAMETER SuppressAlertClear
Indicates whether to suppress alert clear notifications.

.PARAMETER SuppressAlertAckSdt
Indicates whether to suppress alert acknowledgement and SDT notifications.

.PARAMETER LevelStr
Specifies the level string for the alert rule. Valid values: "All", "Critical", "Error", "Warning".

.PARAMETER Description
Specifies the description for the alert rule.

.EXAMPLE
Set-LMAlertRule -Id 123 -Name "Updated Rule" -Priority 100 -EscalatingChainId 456
Updates the alert rule with new name, priority and escalation chain.

.INPUTS
You can pipe alert rule objects containing Id properties to this function.

.OUTPUTS
Returns the response from the API containing the updated alert rule information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMAlertRule {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [Int]$Priority,

        [Int]$EscalatingChainId,

        [Int]$EscalationInterval,

        [Hashtable]$ResourceProperties,

        [String[]]$Devices,

        [String[]]$DeviceGroups,

        [String]$DataSource,

        [String]$DataSourceInstanceName,

        [String]$DataPoint,

        [Boolean]$SuppressAlertClear,

        [Boolean]$SuppressAlertAckSdt,

        [ValidateSet("All", "Critical", "Error", "Warning")]
        [String]$LevelStr,

        [String]$Description
    )

    begin {}

    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup existing alert rule if name is provided
            if ($Name) {
                $AlertRule = Get-LMAlertRule -Name $Name
                if (Test-LookupResult -Result $AlertRule -LookupString $Name) {
                    return
                }
                $Id = $AlertRule.Id
            }

            #Build header and uri
            $ResourcePath = "/setting/alert/rules/$Id"

            #Build body
            $Data = @{}

            #Add updated properties to Data
            if ($NewName) { $Data.Add("name", $NewName) }
            if ($Priority) { $Data.Add("priority", $Priority) }
            if ($EscalationInterval) { $Data.Add("escalationInterval", $EscalationInterval) }
            if ($EscalatingChainId) { $Data.Add("escalatingChainId", $EscalatingChainId) }
            if ($ResourceProperties) { $Data.Add("resourceProperties", $ResourceProperties) }
            if ($Devices) { $Data.Add("devices", $Devices) }
            if ($DeviceGroups) { $Data.Add("deviceGroups", $DeviceGroups) }
            if ($DataSource) { $Data.Add("dataSource", $DataSource) }
            if ($DataSourceInstanceName) { $Data.Add("dataSourceInstanceName", $DataSourceInstanceName) }
            if ($DataPoint) { $Data.Add("dataPoint", $DataPoint) }
            if ($PSBoundParameters.ContainsKey("SuppressAlertClear")) { $Data.Add("suppressAlertClear", $SuppressAlertClear) }
            if ($PSBoundParameters.ContainsKey("SuppressAlertAckSdt")) { $Data.Add("suppressAlertAckSdt", $SuppressAlertAckSdt) }
            if ($LevelStr) { $Data.Add("levelStr", $LevelStr) }
            if ($Description) { $Data.Add("description", $Description) }

            $Data = ($Data | ConvertTo-Json -Depth 10)

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)| Priority: $($PSItem.priority)"
            }
            else {
                $Message = "Id: $Id"
            }

            if ($PSCmdlet.ShouldProcess($Message, "Set Alert Rule")) {
                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertRule")
                }
                catch {
                    return
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }

    end {}
}
