<#
.SYNOPSIS
Creates a new network scan in LogicMonitor.

.DESCRIPTION
The New-LMNetScan function is used to create a new network scan in LogicMonitor. It sends a POST request to the LogicMonitor API to create the network scan with the specified parameters.

.PARAMETER CollectorId
The ID of the collector to use for the network scan. This parameter is mandatory.

.PARAMETER Name
The name of the network scan. This parameter is mandatory.

.PARAMETER Description
The description of the network scan.

.PARAMETER ExcludeDuplicateType
The type of duplicate exclusion to apply. The default value is "1".

.PARAMETER IgnoreSystemIpDuplicates
Specifies whether to ignore duplicate system IPs. The default value is $false.

.PARAMETER Method
The method to use for the network scan. Only "nmap" is supported. The default value is "nmap".

.PARAMETER NextStart
The next start time for the network scan. The default value is "manual".

.PARAMETER NextStartEpoch
The next start time epoch for the network scan. The default value is "0".

.PARAMETER NetScanGroupId
The ID of the network scan group to assign the network scan to. The default value is "1".

.PARAMETER SubnetRange
The subnet range to scan. This parameter is mandatory.

.PARAMETER CredentialGroupId
The ID of the credential group to use for the network scan.

.PARAMETER CredentialGroupName
The name of the credential group to use for the network scan.

.PARAMETER ChangeNameToken
The token to use for changing the name of discovered devices. The default value is "##REVERSEDNS##".

.EXAMPLE
New-LMNetScan -CollectorId "12345" -Name "MyNetScan" -SubnetRange "192.168.0.0/24"
Creates a new network scan with the specified collector ID, name, and subnet range.
#>
function New-LMNetScan {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(Mandatory)]
        [String]$CollectorId,

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [String]$ExcludeDuplicateType = "1",

        [Nullable[boolean]]$IgnoreSystemIpDuplicates = $false,

        [ValidateSet("nmap")]
        [String]$Method = "nmap",

        [String]$NextStart = "manual",

        [String]$NextStartEpoch = "0",

        [String]$NetScanGroupId = "1",

        [PSCustomObject]$Schedule,

        [Parameter(Mandatory)]
        [String]$SubnetRange,

        [SecureString]$CredentialGroupId,

        [SecureString]$CredentialGroupName,

        [String]$ChangeNameToken = "##REVERSEDNS##"
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans"

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

            $DDR = @{
                assignment = @()
                changeName = $ChangeNameToken
            }

            $Creds = @{
                custom          = @()
                deviceGroupId   = $CredentialGroupId
                deviceGroupName = $CredentialGroupName
            }

            $Ports = @{
                isGlobalDefault = $true
                value           = "21,22,23,25,53,69,80,81,110,123,135,143,389,443,445,631,993,1433,1521,3306,3389,5432,5672,6081,7199,8000,8080,8081,9100,10000,11211,27017"
            }

            if (!$Schedule) {
                $Schedule = @{
                    cron       = ""
                    notify     = $false
                    recipients = @()
                    timezone   = "America/New_York"
                    type       = "manual"
                }
            }
            else {
                Test-LMScheduleSchema -Schedule $Schedule
            }

            $Data = @{
                name                      = $Name
                collector                 = $CollectorId
                description               = $Description
                duplicate                 = $Duplicates
                ignoreSystemIPsDuplicates = $IgnoreSystemIpDuplicates
                method                    = $Method
                nextStart                 = $NextStart
                nextStartEpoch            = $NextStartEpoch
                nsgId                     = $NetScanGroupId
                subnet                    = $SubnetRange
                ddr                       = $DDR
                credentials               = $Creds
                ports                     = $Ports
                schedule                  = $Schedule
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys @()

            $Message = "Name: $Name | SubnetRange: $SubnetRange"

            if ($PSCmdlet.ShouldProcess($Message, "Create Netscan")) {
                try {

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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