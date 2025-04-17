<#
.SYNOPSIS
Creates a new LogicMonitor alert rule.

.DESCRIPTION
The New-LMAlertRule function creates a new alert rule in LogicMonitor.

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
New-LMAlertRule -Name "New Rule" -Priority 100 -EscalatingChainId 456
Creates a new alert rule with specified name, priority and escalation chain.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the response from the API containing the new alert rule information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function New-LMAlertRule {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Low')]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory)]
        [Int]$Priority,

        [Parameter(Mandatory)]
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
        [String]$LevelStr = "All",

        [String]$Description
    )

    Begin {}

    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/alert/rules"

            #Build body
            $Data = @{
                name = $Name
                priority = $Priority
                escalatingChainId = $EscalatingChainId
                levelStr = $LevelStr
            }

            #Add optional properties to Data
            If ($EscalationInterval) { $Data.Add("escalationInterval", $EscalationInterval) }
            If ($ResourceProperties) { $Data.Add("resourceProperties", $ResourceProperties) }
            If ($Devices) { $Data.Add("devices", $Devices) }
            If ($DeviceGroups) { $Data.Add("deviceGroups", $DeviceGroups) }
            If ($DataSource) { $Data.Add("dataSource", $DataSource) }
            If ($DataSourceInstanceName) { $Data.Add("dataSourceInstanceName", $DataSourceInstanceName) }
            If ($DataPoint) { $Data.Add("dataPoint", $DataPoint) }
            If ($PSBoundParameters.ContainsKey("SuppressAlertClear")) { $Data.Add("suppressAlertClear", $SuppressAlertClear) }
            If ($PSBoundParameters.ContainsKey("SuppressAlertAckSdt")) { $Data.Add("suppressAlertAckSdt", $SuppressAlertAckSdt) }
            If ($Description) { $Data.Add("description", $Description) }
            
            $Data = ($Data | ConvertTo-Json -Depth 10)

            $Message = "Name: $Name | Priority: $Priority | EscalatingChainId: $EscalatingChainId"

            If ($PSCmdlet.ShouldProcess($Message, "Create Alert Rule")) {
                Try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertRule")
                }
                Catch [Exception] {
                    $Proceed = Resolve-LMException -LMException $PSItem
                    If (!$Proceed) {
                        Return
                    }
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }

    End {}
}
