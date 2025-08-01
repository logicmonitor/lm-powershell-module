<#
.SYNOPSIS
Creates a new LogicMonitor collector.

.DESCRIPTION
The New-LMCollector function creates a new collector in LogicMonitor with specified configuration settings.

.PARAMETER Description
The description of the collector. This parameter is mandatory.

.PARAMETER BackupAgentId
The ID of the backup collector.

.PARAMETER CollectorGroupId
The ID of the collector group to assign the collector to.

.PARAMETER Properties
A hashtable of custom properties for the collector.

.PARAMETER EnableFailBack
Whether to enable failback for the collector.

.PARAMETER EnableFailOverOnCollectorDevice
Whether to enable failover on the collector device.

.PARAMETER EscalatingChainId
The ID of the escalation chain to use.

.PARAMETER AutoCreateCollectorDevice
Whether to automatically create a device for the collector.

.PARAMETER SuppressAlertClear
Whether to suppress alert clear notifications.

.PARAMETER ResendAlertInterval
The interval for resending alerts.

.PARAMETER SpecifiedCollectorDeviceGroupId
The ID of the device group for the collector device.

.EXAMPLE
#Create a new collector
New-LMCollector -Description "Production Collector" -CollectorGroupId 123 -Properties @{"location"="datacenter1"}

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Collector object.
#>
function New-LMCollector {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$Description,

        [Nullable[Int]]$BackupAgentId,

        [Nullable[Int]]$CollectorGroupId,

        [Hashtable]$Properties,

        [Nullable[boolean]]$EnableFailBack,

        [Nullable[boolean]]$EnableFailOverOnCollectorDevice,

        [Nullable[Int]]$EscalatingChainId,

        [Nullable[boolean]]$AutoCreateCollectorDevice,

        [Nullable[boolean]]$SuppressAlertClear,

        [Nullable[Int]]$ResendAlertInterval,

        [Nullable[Int]]$SpecifiedCollectorDeviceGroupId

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
            $ResourcePath = "/setting/collector/collectors"

            $Data = @{
                description                     = $Description
                backupAgentId                   = $BackupAgentId
                collectorGroupId                = $CollectorGroupId
                customProperties                = $customProperties
                enableFailBack                  = $EnableFailBack
                enableFailOverOnCollectorDevice = $EnableFailOverOnCollectorDevice
                escalatingChainId               = $EscalatingChainId
                needAutoCreateCollectorDevice   = $AutoCreateCollectorDevice
                suppressAlertClear              = $SuppressAlertClear
                resendIval                      = $ResendAlertInterval
                netflowCollectorId              = $NetflowCollectorId
                specifiedCollectorDeviceGroupId = $SpecifiedCollectorDeviceGroupId
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Description: $Description"

            if ($PSCmdlet.ShouldProcess($Message, "Create Collector")) {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Collector" )

            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
