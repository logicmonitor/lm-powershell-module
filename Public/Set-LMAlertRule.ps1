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

Function Set-LMAlertRule {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
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

    Begin {}

    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup existing alert rule if name is provided
            If ($Name) {
                $AlertRule = Get-LMAlertRule -Name $Name
                If (Test-LookupResult -Result $AlertRule -LookupString $Name) {
                    return
                }
                $Id = $AlertRule.Id
            }

            #Build header and uri
            $ResourcePath = "/setting/alert/rules/$Id"

            #Build body
            $Data = @{}

            #Add updated properties to Data
            If ($NewName) { $Data.Add("name", $NewName) }
            If ($Priority) { $Data.Add("priority", $Priority) }
            If ($EscalationInterval) { $Data.Add("escalationInterval", $EscalationInterval) }
            If ($EscalatingChainId) { $Data.Add("escalatingChainId", $EscalatingChainId) }
            If ($ResourceProperties) { $Data.Add("resourceProperties", $ResourceProperties) }
            If ($Devices) { $Data.Add("devices", $Devices) }
            If ($DeviceGroups) { $Data.Add("deviceGroups", $DeviceGroups) }
            If ($DataSource) { $Data.Add("dataSource", $DataSource) }
            If ($DataSourceInstanceName) { $Data.Add("dataSourceInstanceName", $DataSourceInstanceName) }
            If ($DataPoint) { $Data.Add("dataPoint", $DataPoint) }
            If ($PSBoundParameters.ContainsKey("SuppressAlertClear")) { $Data.Add("suppressAlertClear", $SuppressAlertClear) }
            If ($PSBoundParameters.ContainsKey("SuppressAlertAckSdt")) { $Data.Add("suppressAlertAckSdt", $SuppressAlertAckSdt) }
            If ($LevelStr) { $Data.Add("levelStr", $LevelStr) }
            If ($Description) { $Data.Add("description", $Description) }
            
            $Data = ($Data | ConvertTo-Json -Depth 10)

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)| Priority: $($PSItem.priority)"
            }
            Else {
                $Message = "Id: $Id"
            }

            If ($PSCmdlet.ShouldProcess($Message, "Set Alert Rule")) {
                Try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
