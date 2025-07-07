<#
.SYNOPSIS
Creates a new enhanced network scan in LogicMonitor.

.DESCRIPTION
The New-LMEnhancedNetScan function creates a new enhanced network scan in LogicMonitor. It allows you to specify various parameters such as the collector ID, name, net scan group name, custom credentials, filters, description, exclude duplicate type, method, next start, next start epoch, Groovy script, credential group ID, and credential group name.

.PARAMETER CollectorId
The ID of the collector where the network scan will be executed.

.PARAMETER Name
The name of the network scan.

.PARAMETER NetScanGroupName
The name of the net scan group.

.PARAMETER CustomCredentials
A list of custom credentials to be used for the network scan.

.PARAMETER Filters
A list of filters to be applied to the network scan.

.PARAMETER Description
A description of the network scan.

.PARAMETER ExcludeDuplicateType
The type of duplicates to be excluded. Default value is "1".

.PARAMETER Method
The method to be used for the network scan. Default value is "enhancedScript".

.PARAMETER NextStart
The next start time for the network scan. Default value is "manual".

.PARAMETER NextStartEpoch
The next start epoch for the network scan. Default value is "0".

.PARAMETER GroovyScript
The Groovy script to be executed during the network scan.

.PARAMETER CredentialGroupId
The ID of the credential group to be used for the network scan.

.PARAMETER CredentialGroupName
The name of the credential group to be used for the network scan.

.EXAMPLE
New-LMEnhancedNetScan -CollectorId "12345" -Name "MyNetScan" -NetScanGroupName "Group1" -CustomCredentials $customCreds -Filters $filters -Description "This is a network scan" -ExcludeDuplicateType "1" -Method "enhancedScript" -NextStart "manual" -NextStartEpoch "0" -GroovyScript "script" -CredentialGroupId "67890" -CredentialGroupName "Group2"

This example creates a new enhanced network scan with the specified parameters.

.NOTES
For more information about LogicMonitor network scans, refer to the LogicMonitor documentation.
#>
function New-LMEnhancedNetScan {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$CollectorId,

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$NetScanGroupName,

        [System.Collections.Generic.List[PSCustomObject]]$CustomCredentials,

        [System.Collections.Generic.List[PSCustomObject]]$Filters,

        [String]$Description,

        [String]$ExcludeDuplicateType = "1",

        [ValidateSet("enhancedScript")]
        [String]$Method = "enhancedScript",

        [String]$NextStart = "manual",

        [String]$NextStartEpoch = "0",

        [String]$GroovyScript,

        [SecureString]$CredentialGroupId,

        [SecureString]$CredentialGroupName
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans"

            #Get Netscan GroupID
            if ($NetScanGroupName) {
                $NetScanGroupId = (Get-LMNetScanGroup -Name $NetScanGroupName).Id
            }
            else {
                $NetScanGroupId = 1
            }

            #Get cred group name
            if ($CredentialGroupId -and !$CredentialGroupName) {
                $CredentialGroupName = (Get-LMDeviceGroup -Id $CredentialGroupId).Name
            }

            #Get cred group name
            if ($CredentialGroupName -and !$CredentialGroupId) {
                $CredentialGroupName = (Get-LMDeviceGroup -Name $CredentialGroupName).Id
            }

            $Duplicates = @{
                collectors = @()
                groups     = @()
                type       = $ExcludeDuplicateType
            }

            $Creds = @{
                custom          = $CustomCredentials
                deviceGroupId   = $CredentialGroupId
                deviceGroupName = $CredentialGroupName
            }

            $Schedule = @{
                cron       = ""
                notify     = $false
                recipients = @()
                timezone   = "America/New_York"
                type       = "manual"
            }

            $Data = @{
                name           = $Name
                collector      = $CollectorId
                description    = $Description
                duplicate      = $Duplicates
                method         = $Method
                nextStart      = $NextStart
                groovyScript   = $GroovyScript
                nextStartEpoch = $NextStartEpoch
                nsgId          = $NetScanGroupId
                credentials    = $Creds
                filters        = $Filters
                schedule       = $Schedule
                scriptType     = "embeded"
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name | CollectorId: $CollectorId"

            if ($PSCmdlet.ShouldProcess($Message, "Create Enhanced Netscan")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScan" )
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
