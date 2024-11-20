<#
.SYNOPSIS
Sets the properties of a LogicMonitor device datasource instance.

.DESCRIPTION
The Set-LMDeviceDatasourceInstance function is used to set the properties of a LogicMonitor device datasource instance. It allows you to update the display name, wild values, description, custom properties, monitoring and alerting settings, and instance group ID of the specified instance.

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
Specifies the method to use when updating the properties. Valid values are "Add", "Replace", or "Refresh".

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the instance. This parameter accepts $true or $false.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the instance. This parameter accepts $true or $false.

.PARAMETER InstanceGroupId
Specifies the ID of the instance group to which the instance belongs.

.PARAMETER InstanceId
Specifies the ID of the instance to update. This parameter is mandatory and can be provided via pipeline.

.PARAMETER DatasourceName
Specifies the name of the datasource associated with the instance. This parameter is mandatory when using the 'Name-dsName' parameter set.

.PARAMETER DatasourceId
Specifies the ID of the datasource associated with the instance. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter set.

.PARAMETER Id
Specifies the ID of the device associated with the instance. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter set. This parameter can also be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device associated with the instance. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter set. This parameter can also be specified using the 'DeviceName' alias.

.EXAMPLE
Set-LMDeviceDatasourceInstance -InstanceId 12345 -DisplayName "New Instance Name" -Description "Updated instance description"

This example sets the display name and description of the instance with ID 12345.

.EXAMPLE
Get-LMDevice -Name "MyDevice" | Set-LMDeviceDatasourceInstance -DatasourceName "MyDatasource" -DisplayName "New Instance Name"

This example retrieves the device with the name "MyDevice" and sets the display name of the instance associated with the datasource "MyDatasource".

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

            Try {
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
                @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Device Datasource Instance")) { 
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceDatasourceInstance" )
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
