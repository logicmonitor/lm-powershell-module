<#
.SYNOPSIS
Creates a new LogicMonitor device.

.DESCRIPTION
The New-LMDevice function creates a new device in LogicMonitor with specified configuration settings.

.PARAMETER Name
The name of the device. This parameter is mandatory.

.PARAMETER DisplayName
The display name of the device. This parameter is mandatory.

.PARAMETER Description
The description of the device.

.PARAMETER PreferredCollectorId
The ID of the preferred collector for the device. This parameter is mandatory.

.PARAMETER PreferredCollectorGroupId
The ID of the preferred collector group for the device.

.PARAMETER AutoBalancedCollectorGroupId
The ID of the auto-balanced collector group for the device.

.PARAMETER DeviceType
The type of the device. Defaults to 0.

.PARAMETER Properties
A hashtable of custom properties for the device.

.PARAMETER HostGroupIds
An array of host group IDs. Dynamic group IDs will be ignored.

.PARAMETER Link
The link associated with the device.

.PARAMETER DisableAlerting
Whether to disable alerting for the device.

.PARAMETER EnableNetFlow
Whether to enable NetFlow for the device.

.PARAMETER NetflowCollectorGroupId
The ID of the NetFlow collector group.

.PARAMETER NetflowCollectorId
The ID of the NetFlow collector.

.PARAMETER LogCollectorGroupId
The ID of the log collector group.

.PARAMETER LogCollectorId
The ID of the log collector.

.EXAMPLE
#Create a new device
New-LMDevice -Name "server1" -DisplayName "Server 1" -PreferredCollectorId 123 -Properties @{"location"="datacenter1"}

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Device object.
#>
function New-LMDevice {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DisplayName,

        [String]$Description,

        [Parameter(Mandatory)]
        [Nullable[Int]]$PreferredCollectorId,

        [Nullable[Int]]$PreferredCollectorGroupId,

        [Nullable[Int]]$AutoBalancedCollectorGroupId,

        [Int]$DeviceType = 0,

        [Hashtable]$Properties,

        [String[]]$HostGroupIds, #Dynamic group ids will be ignored, operation will replace all existing groups

        [String]$Link,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [Nullable[Int]]$NetflowCollectorGroupId,

        [Nullable[Int]]$NetflowCollectorId,

        [Nullable[Int]]$LogCollectorGroupId,

        [Nullable[Int]]$LogCollectorId
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/device/devices"

            $Data = @{
                name                         = $Name
                displayName                  = $DisplayName
                description                  = $Description
                disableAlerting              = $DisableAlerting
                enableNetflow                = $EnableNetFlow
                customProperties             = $customProperties
                deviceType                   = $DeviceType
                preferredCollectorId         = $PreferredCollectorId
                preferredCollectorGroupId    = $PreferredCollectorGroupId
                autoBalancedCollectorGroupId = $AutoBalancedCollectorGroupId
                link                         = $Link
                netflowCollectorGroupId      = $NetflowCollectorGroupId
                netflowCollectorId           = $NetflowCollectorId
                logCollectorGroupId          = $LogCollectorGroupId
                logCollectorId               = $LogCollectorId
                hostGroupIds                 = $HostGroupIds -join ","
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name | DisplayName: $DisplayName"

            if ($PSCmdlet.ShouldProcess($Message, "Create Device")) {
                

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
