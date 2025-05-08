<#
.SYNOPSIS
Invokes an active discovery task for LogicMonitor devices.

.DESCRIPTION
The Invoke-LMActiveDiscovery function schedules an active discovery task for LogicMonitor devices. It can target individual devices or device groups using either ID or name.

.PARAMETER Id
The ID of the device to run active discovery on. Required for Id parameter set.

.PARAMETER Name
The name of the device to run active discovery on. Required for Name parameter set.

.PARAMETER GroupId
The ID of the device group to run active discovery on. Required for GroupId parameter set.

.PARAMETER GroupName
The name of the device group to run active discovery on. Required for GroupName parameter set.

.EXAMPLE
#Run active discovery on a device by ID
Invoke-LMActiveDiscovery -Id 12345

.EXAMPLE
#Run active discovery on a device group by name
Invoke-LMActiveDiscovery -GroupName "Production-Servers"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the task is scheduled successfully.
#>
Function Invoke-LMActiveDiscovery {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [String]$GroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$GroupName
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            $deviceList = @()

            #Lookup device name
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $deviceList = $LookupResult
            }
            Elseif ($Id) {
                $deviceList = $Id
            }

            #Look up devices by group
            If ($GroupName) {
                If ($GroupName -Match "\*") {
                    Write-Error "Wildcard values not supported for group names." 
                    return
                }
                $deviceList = (Get-LMDeviceGroupDevices -Name $GroupName).Id
                If (!$deviceList) {
                    Write-Error "Unable to find devices for group: $GroupName, please check spelling and try again." 
                    return
                }
            }
            Elseif ($GroupId) {
                $deviceList = (Get-LMDeviceGroupDevices -Id $GroupId).Id
                If (!$deviceList) {
                    Write-Error "Unable to find devices for groupId: $GroupId, please check spelling and try again." 
                    return
                }
            }
                    
            
            #Loop through requests 
            Foreach ($device in $deviceList) {
                
                #Build header and uri
                $ResourcePath = "/device/devices/$device/scheduleAutoDiscovery"
               
                Try {
    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    Write-Information "[INFO]: Scheduled Active Discovery task for device id: $device."
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
