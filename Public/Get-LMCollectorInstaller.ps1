<#
.SYNOPSIS
Downloads the LogicMonitor Collector installer.

.DESCRIPTION
The Get-LMCollectorInstaller function downloads the LogicMonitor Collector installer based on the specified parameters. It supports different operating systems, architectures, and collector sizes, and can download either standard or Early Access (EA) versions.

.PARAMETER Id
The ID of the collector to download the installer for. This parameter is mandatory when using the Id parameter set.

.PARAMETER Name
The name of the collector to download the installer for. This parameter is mandatory when using the Name parameter set.

.PARAMETER Size
The size of the collector to install. Valid values are 'nano', 'small', 'medium', 'large', 'extra_large', 'double_extra_large'. Defaults to 'medium'.

.PARAMETER OSandArch
The operating system and architecture for the installer. Valid values are 'Win64', 'Linux64'. Defaults to 'Win64'.

.PARAMETER UseEA
Switch to use the Early Access version of the collector. Defaults to $false.

.PARAMETER DownloadPath
The path where the installer file will be saved. Defaults to the current directory.

.EXAMPLE
#Download a Windows collector installer
Get-LMCollectorInstaller -Id 123 -Size medium -OSandArch Win64 -DownloadPath "C:\Downloads"

.EXAMPLE
#Download a Linux collector installer with Early Access
Get-LMCollectorInstaller -Name "Collector1" -OSandArch Linux64 -UseEA $true

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the path to the downloaded installer file.
#>
Function Get-LMCollectorInstaller {
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = "Id")]
        [int]$Id,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [string]$Name,

        [ValidateSet("nano", "small", "medium", "large", "extra_large", "double_extra_large")]
        [string]$Size = "medium",

        [ValidateSet("Win64", "Linux64")]
        [string]$OSandArch = "Win64",

        [boolean]$UseEA = $false,

        [string]$DownloadPath = (Get-Location).Path
    )
    
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMCollector -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/collector/collectors/$Id/installers/$OSandArch"
        $QueryParams = "?useEA=$UseEA&collectorSize=$Size"

        If ($OSandArch -like "Linux*") {
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch`_$Size`_$Id.bin"
        }
        Else {
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch`_$Size`_$Id.exe"
        }

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1] -OutFile $DownloadPath
            
            Return $DownloadPath

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
