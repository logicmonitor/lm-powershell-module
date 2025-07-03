<#
.SYNOPSIS
Updates a LogicMonitor NetScan configuration.

.DESCRIPTION
The Set-LMNetscan function modifies an existing NetScan configuration in LogicMonitor.

.PARAMETER CollectorId
Specifies the ID of the collector to use for the NetScan.

.PARAMETER Name
Specifies the name of the NetScan.

.PARAMETER Id
Specifies the ID of the NetScan to modify.

.PARAMETER Description
Specifies the description for the NetScan.

.PARAMETER ExcludeDuplicateType
Specifies the type of duplicates to exclude.

.PARAMETER IgnoreSystemIpDuplpicates
Specifies whether to ignore system IP duplicates.

.PARAMETER Method
Specifies the scanning method to use.

.PARAMETER NextStart
Specifies when the next scan should start.

.PARAMETER NextStartEpoch
Specifies when the next scan should start in epoch time.

.PARAMETER NetScanGroupId
Specifies the ID of the NetScan group.

.PARAMETER SubnetRange
Specifies the subnet range to scan.

.PARAMETER CredentialGroupId
Specifies the ID of the credential group.

.PARAMETER CredentialGroupName
Specifies the name of the credential group.

.PARAMETER Schedule
Specifies the scanning schedule configuration.

.PARAMETER ChangeNameToken
Specifies the token for changing names.

.PARAMETER PortList
Specifies the list of ports to scan.

.EXAMPLE
Set-LMNetscan -Id 123 -Name "UpdatedScan" -Description "New description"
Updates the NetScan with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.NetScan object containing the updated scan configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
Function Set-LMNetscan {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (

        [String]$CollectorId,

        [String]$Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Description,
        
        [String]$ExcludeDuplicateType,

        [Nullable[boolean]]$IgnoreSystemIpDuplpicates,

        [String]$Method,

        [String]$NextStart,

        [String]$NextStartEpoch,

        [String]$NetScanGroupId,

        [String]$SubnetRange,

        [String]$CredentialGroupId,

        [String]$CredentialGroupName,

        [PSCustomObject]$Schedule,

        [String]$ChangeNameToken,

        [String]$PortList
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }

            #Get cred group name
            If ($CredentialGroupId -and !$CredentialGroupName) {
                $CredentialGroupName = (Get-LMDeviceGroup -Id $CredentialGroupId).Name
            }

            #Get cred group name
            If ($CredentialGroupName -and !$CredentialGroupId) {
                $CredentialGroupName = (Get-LMDeviceGroup -Name $CredentialGroupName).Id
            }

            $Duplicates = $null
            If ($ExcludeDuplicateType) {
                $Duplicates = @{
                    collectors = @()
                    groups     = @()
                    type       = $ExcludeDuplicateType
                }
            }

            $DDR = $null
            If ($ChangeNameToken) {
                $DDR = @{
                    assignment = @()
                    changeName = $ChangeNameToken
                }
            }

            $Creds = $null
            If ($CredentialGroupId -or $CredentialGroupName) {
                $Creds = @{
                    custom          = @()
                    deviceGroupId   = $CredentialGroupId
                    deviceGroupName = $CredentialGroupName
                }
            }

            $Ports = $null
            If ($PortList) {
                $Ports = @{
                    isGlobalDefault = $true
                    value           = $PortList
                }
            }

            Try {
                $Data = @{
                    id                        = $Id
                    name                      = $Name
                    collector                 = $CollectorId
                    description               = $Description
                    duplicate                 = $Duplicates
                    ignoreSystemIPsDuplicates = $IgnoreSystemIpDuplpicates
                    method                    = $Method
                    nextStart                 = $NextStart
                    nextStartEpoch            = $NextStartEpoch
                    nsgId                     = $NetScanGroupId
                    subnet                    = $SubnetRange
                    ddr                       = $DDR
                    credentials               = $Creds
                    ports                     = $Ports
                    schedule                  = If($Schedule){$Schedule}Else{$null}
                }

                
                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

                If ($PSCmdlet.ShouldProcess($Message, "Set NetScan")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScan" )
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
