<#
.SYNOPSIS
Updates a LogicMonitor device datasource instance configuration.

.DESCRIPTION
The Set-LMDeviceDatasourceInstance function modifies an existing device datasource instance in LogicMonitor, allowing updates to its display name, wild values, description, and various other properties.

.PARAMETER DisplayName
Specifies the new display name for the instance.

.PARAMETER WildValue
Specifies the first wild value for the instance.

.PARAMETER WildValue2
Specifies the second wild value for the instance.

.PARAMETER Description
Specifies the description for the instance.

.PARAMETER Properties
Specifies a hashtable of custom properties for the instance.

.PARAMETER PropertiesMethod
Specifies how to handle existing properties. Valid values are "Add", "Replace", or "Refresh". Default is "Replace".

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the instance.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the instance.

.PARAMETER InstanceGroupId
Specifies the ID of the instance group to which the instance belongs.

.PARAMETER InstanceId
Specifies the ID of the instance to update.

.PARAMETER DatasourceName
Specifies the name of the datasource associated with the instance.

.PARAMETER DatasourceId
Specifies the ID of the datasource associated with the instance.

.PARAMETER Id
Specifies the ID of the device associated with the instance.

.PARAMETER Name
Specifies the name of the device associated with the instance.

.EXAMPLE
Set-LMDeviceDatasourceInstance -InstanceId 123 -DisplayName "Updated Instance" -Description "New description"
Updates the instance with ID 123 with a new display name and description.

.INPUTS
You can pipe objects containing InstanceId, DatasourceId, and Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.DeviceDatasourceInstance object containing the updated instance information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMDeviceDatasourceInstance {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [String]$DisplayName,
        
        [String]$WildValue,

        [String]$WildValue2,

        [String]$Description,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$DisableAlerting,

        [String]$InstanceGroupId,
        
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$InstanceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Alias('DeviceId')]
        [String]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias('DeviceName')]
        [String]$Name

    )

    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Device Id
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup DatasourceId
            If ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$instanceId"

            If ($PSItem) {
                $Message = "deviceDisplayName: $($PSItem.deviceDisplayName) | instanceId: $($PSItem.id) | instanceName: $($PSItem.name)"
            }
            Elseif ($Name) {
                $Message = "deviceDisplayName: $Name | instanceId: $InstanceId"
            }
            Else {
                $Message = "instanceId: $InstanceId | Id: $Id"
            }

            $Data = @{
                    displayName      = $DisplayName
                    description      = $Description
                    wildValue        = $WildValue
                    wildValue2       = $WildValue2
                    stopMonitoring   = $StopMonitoring
                    disableAlerting  = $DisableAlerting
                    customProperties = $customProperties
                    groupId          = $InstanceGroupId
                }

                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -ConditionalValueKeep @{ 'PropertiesMethod' = @(@{ Value = 'Refresh'; KeepKeys = @('customProperties') }) } `
                    -Context @{ PropertiesMethod = $PropertiesMethod }

                If ($PSCmdlet.ShouldProcess($Message, "Set Device Datasource Instance")) { 
                    Try {
                        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                        #Issue request using new centralized method with retry logic
                        $Response = Invoke-LMRestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                        Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceDatasourceInstance" )
                    }
                    Catch {
                        # Error is already displayed by Resolve-LMException, just return cleanly
                        return
                    }
                }
            }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
