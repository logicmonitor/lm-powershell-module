<#
.SYNOPSIS
Updates a LogicMonitor collector's configuration.

.DESCRIPTION
The Set-LMCollector function modifies an existing collector's settings in LogicMonitor, including its description, backup agent, group, and various properties.

.PARAMETER Id
Specifies the ID of the collector to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the collector to modify. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Description
Specifies a new description for the collector.

.PARAMETER BackupAgentId
Specifies the ID of the backup collector.

.PARAMETER CollectorGroupId
Specifies the ID of the collector group to which this collector should belong.

.PARAMETER Properties
Specifies a hashtable of custom properties to set for the collector.

.PARAMETER EnableFailBack
Specifies whether to enable fail-back functionality.

.PARAMETER EnableFailOverOnCollectorDevice
Specifies whether to enable fail-over on the collector device.

.PARAMETER EscalatingChainId
Specifies the ID of the escalation chain.

.PARAMETER SuppressAlertClear
Specifies whether to suppress alert clear notifications.

.PARAMETER ResendAlertInterval
Specifies the interval for resending alerts.

.PARAMETER SpecifiedCollectorDeviceGroupId
Specifies the ID of the device group for the collector.

.EXAMPLE
Set-LMCollector -Id 123 -Description "Updated collector" -EnableFailBack $true
Updates the collector with ID 123 with a new description and enables fail-back.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.Collector object containing the updated collector information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMCollector {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$Description,

        [Nullable[Int]]$BackupAgentId,

        [Nullable[Int]]$CollectorGroupId,

        [Hashtable]$Properties,

        [Nullable[boolean]]$EnableFailBack,

        [Nullable[boolean]]$EnableFailOverOnCollectorDevice,

        [Nullable[Int]]$EscalatingChainId,

        [Nullable[boolean]]$SuppressAlertClear,

        [Nullable[Int]]$ResendAlertInterval,

        [Nullable[Int]]$SpecifiedCollectorDeviceGroupId

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            #Lookup Collector Name
            if ($Name) {
                $LookupResult = (Get-LMCollector -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            if ($Properties) {
                foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            #Build header and uri
            $ResourcePath = "/setting/collector/collectors/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.hostname) | Description: $($PSItem.description)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name)"
            }
            else {
                $Message = "Id: $Id"
            }

            
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
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set Collector")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Collector" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
