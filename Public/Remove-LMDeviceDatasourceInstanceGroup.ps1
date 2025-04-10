<#
.SYNOPSIS
Removes a LogicMonitor device datasource instance group.

.DESCRIPTION
The Remove-LMDeviceDatasourceInstanceGroup function removes a LogicMonitor device datasource instance group based on the provided parameters. It requires valid API credentials and a logged-in session.

.PARAMETER DatasourceName
Specifies the name of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device associated with the instance group. This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets. This parameter can also be specified using the 'DeviceId' alias.

.PARAMETER Name
Specifies the name of the device associated with the instance group. This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets. This parameter can also be specified using the 'DeviceName' alias.

.PARAMETER InstanceGroupName
Specifies the name of the instance group to be removed. This parameter is mandatory.

.PARAMETER InstanceGroupId
Specifies the ID of the instance group to be removed. This parameter is mandatory.

.PARAMETER HdsId
Specifies the ID of the host datasource associated with the instance group. This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets. 

.EXAMPLE
Remove-LMDeviceDatasourceInstanceGroup -DatasourceName "CPU" -Name "Server01" -InstanceGroupName "Group1"
Removes the instance group named "Group1" associated with the "CPU" datasource on the device named "Server01".

.EXAMPLE
Remove-LMDeviceDatasourceInstanceGroup -DatasourceId 123 -Id 456 -InstanceGroupName "Group2"
Removes the instance group named "Group2" associated with the datasource ID 123 on the device ID 456.

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the instance ID and a message confirming the successful removal of the instance group.
#>

Function Remove-LMDeviceDatasourceInstanceGroup {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High', DefaultParameterSetName = 'Id-dsName-GroupName')]
    Param (
        # Datasource Name Parameter Sets
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupId')]
        [String]$DatasourceName,

        # Datasource ID Parameter Sets
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupId')]
        [Int]$DatasourceId,

        # Device ID Parameter Sets
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupId')]
        [Alias('DeviceId')]
        [Int]$Id,

        # Device Name Parameter Sets
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupId')]
        [Alias('DeviceName')]
        [String]$Name,

        # Host Datasource ID (HdsId) Parameter Sets
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupId')]
        [String]$HdsId,

        # Instance Group Name (Mutually Exclusive with InstanceGroupId)
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupName')]
        [String]$InstanceGroupName,

        # Instance Group ID (Mutually Exclusive with InstanceGroupName)
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId-GroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId-GroupId')]
        [String]$InstanceGroupId
    )

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        # Lookup Device Id if Name provided
        If ($PSBoundParameters.ContainsKey('Name')) { # Check if Name was used
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        # Lookup Host Datasource ID (HdsId) if Datasource Name/ID provided
        If ($PSBoundParameters.ContainsKey('DatasourceName') -or $PSBoundParameters.ContainsKey('DatasourceId')) { # Check if DatasourceName/ID was used
             # Determine the lookup value based on provided parameter
            $DatasourceLookupValue = if ($PSBoundParameters.ContainsKey('DatasourceName')) { $DatasourceName } else { $DatasourceId }
            $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { ($_.dataSourceName -eq $DatasourceName -and $PSBoundParameters.ContainsKey('DatasourceName')) -or ($_.dataSourceId -eq $DatasourceId -and $PSBoundParameters.ContainsKey('DatasourceId')) }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceLookupValue) {
                return
            }
            $HdsId = $LookupResult
        }
        # Note: If HdsId was provided directly, we use that value and skip the lookup above.

        # Lookup InstanceGroupId if InstanceGroupName provided
        # Only perform lookup if InstanceGroupName parameter was actually used
        If ($PSBoundParameters.ContainsKey('InstanceGroupName')) {
            Write-Verbose "Looking up Instance Group ID for Name: $InstanceGroupName"
            $LookupResult = (Get-LMDeviceDatasourceInstanceGroup -Id $Id -HdsId $HdsId -Filter "name -eq '$InstanceGroupName'").Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceGroupName) {
                return
            }
            # Assign the found ID to InstanceGroupId for use later
            $InstanceGroupId = $LookupResult
        }
        # If InstanceGroupId was provided directly, we use that value.

        # Build header and uri - uses $InstanceGroupId which is now always populated correctly
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/groups/$InstanceGroupId"

        # Construct message for ShouldProcess
        $DeviceIdentifier = if ($PSBoundParameters.ContainsKey('Name')) { "DeviceName: $Name" } else { "DeviceId: $Id" }
        $DatasourceIdentifier = if ($PSBoundParameters.ContainsKey('DatasourceName')) { "DatasourceName: $DatasourceName" } elseif ($PSBoundParameters.ContainsKey('DatasourceId')) { "DatasourceId: $DatasourceId" } else { "HdsId: $HdsId" }
        $InstanceIdentifier = if ($PSBoundParameters.ContainsKey('InstanceGroupName')) { "InstanceGroupName: $InstanceGroupName" } else { "InstanceGroupId: $InstanceGroupId" }

        $Message = "$DeviceIdentifier | $DatasourceIdentifier | $InstanceIdentifier"


        Try {
            If ($PSCmdlet.ShouldProcess($Message, "Remove Device Datasource Instance Group")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]

                # Adjusted output object to reflect correct ID used
                $Result = [PSCustomObject]@{
                    InstanceGroupId = $InstanceGroupId # Output the ID used for deletion
                    Message         = "Successfully removed ($Message)"
                }

                Return $Result
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
