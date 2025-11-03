<#
.SYNOPSIS
Updates a LogicMonitor collector's configuration settings.

.DESCRIPTION
The Set-LMCollectorConfig function modifies detailed configuration settings for a collector, including SNMP settings, script settings, and various other parameters. This operation will restart the collector.

.PARAMETER Id
Specifies the ID of the collector to configure.

.PARAMETER Name
Specifies the name of the collector to configure.

.PARAMETER CollectorSize
Specifies the size of the collector. Valid values are "nano", "small", "medium", "large", "extra_large", "double_extra_large".

.PARAMETER CollectorConf
Specifies the collector configuration file content.

.PARAMETER SbproxyConf
Specifies the sbproxy configuration file content.

.PARAMETER WatchdogConf
Specifies the watchdog configuration file content.

.PARAMETER WebsiteConf
Specifies the website configuration file content.

.PARAMETER WrapperConf
Specifies the wrapper configuration file content.

.PARAMETER SnmpThreadPool
Specifies the SNMP thread pool size for snippet configuration.

.PARAMETER SnmpPduTimeout
Specifies the SNMP PDU timeout in milliseconds for snippet configuration.

.PARAMETER ScriptThreadPool
Specifies the script thread pool size for snippet configuration.

.PARAMETER ScriptTimeout
Specifies the script timeout in seconds for snippet configuration.

.PARAMETER BatchScriptThreadPool
Specifies the batch script thread pool size for snippet configuration.

.PARAMETER BatchScriptTimeout
Specifies the batch script timeout in seconds for snippet configuration.

.PARAMETER PowerShellSPSEProcessCountMin
Specifies the minimum PowerShell SPSE process count for snippet configuration.

.PARAMETER PowerShellSPSEProcessCountMax
Specifies the maximum PowerShell SPSE process count for snippet configuration.

.PARAMETER NetflowEnable
Indicates whether Netflow is enabled for snippet configuration.

.PARAMETER NbarEnable
Indicates whether NBAR is enabled for snippet configuration.

.PARAMETER NetflowPorts
Specifies the Netflow ports for snippet configuration.

.PARAMETER SflowPorts
Specifies the sFlow ports for snippet configuration.

.PARAMETER LMLogsSyslogEnable
Indicates whether LM Logs syslog is enabled for snippet configuration.

.PARAMETER LMLogsSyslogHostnameFormat
Specifies the hostname format for LM Logs syslog. Valid values: "IP", "FQDN", "HOSTNAME".

.PARAMETER LMLogsSyslogPropertyName
Specifies the property name for LM Logs syslog configuration.

.PARAMETER WaitForRestart
Indicates whether to wait for the collector restart to complete.

.EXAMPLE
Set-LMCollectorConfig -Id 123 -CollectorSize "medium" -WaitForRestart
Updates the collector size and waits for the restart to complete.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a string indicating the status of the configuration update and restart operation.

.NOTES
This function requires a valid LogicMonitor API authentication and will restart the collector.
#>

function Set-LMCollectorConfig {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id-Conf', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'Id-SnippetConf', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name-Conf')]
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [ValidateSet("nano", "small", "medium", "large", "extra_large", "double_extra_large")]
        [String]$CollectorSize,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$CollectorConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$SbproxyConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WatchdogConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WebsiteConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WrapperConf,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$SnmpThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$SnmpPduTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$ScriptThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$ScriptTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$BatchScriptThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$BatchScriptTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$PowerShellSPSEProcessCountMin,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$PowerShellSPSEProcessCountMax,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$NetflowEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$NbarEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String[]]$NetflowPorts,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String[]]$SflowPorts,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$LMLogsSyslogEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [ValidateSet("IP", "FQDN", "HOSTNAME")]
        [String]$LMLogsSyslogHostnameFormat,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String]$LMLogsSyslogPropertyName,

        [Switch]$WaitForRestart

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        function Update-CollectorConfig {
            [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseShouldProcessForStateChangingFunctions', '', Justification = 'Required for the function to work')]
            param (
                $Config,
                $ConfLine,
                $Value
            )

            $Value = $Value.toString().toLower()

            $ConfigArray = $Config.Split([Environment]::NewLine)
            [int[]]$Index = [Linq.Enumerable]::Range(0, $ConfigArray.Count).Where({ param($i) $ConfigArray[$i] -match "^$ConfLine" })
            if (($Index | Measure-Object).Count -eq 1) {
                Write-Information "[INFO]: Updating config parameter $ConfLine to value $Value."
                $ConfigArray[$Index[0]] = "$ConfLine=$Value"
            }
            else {
                Write-Warning "[WARN]: Multiple matches found for config parameter $ConfLine, skipping processing."
            }

            return ([string]::Join([Environment]::NewLine, $ConfigArray))
        }

        if ($Script:LMAuth.Valid) {

            #Lookup Collector Name
            if ($Name) {
                $LookupResult = (Get-LMCollector -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($PSCmdlet.ParameterSetName -like "*Snippet*") {
                $CollectorConfData = (Get-LMCollector -Id $Id).collectorConf

                if ($CollectorConfData) {
                    $SnippetArray = [System.Collections.ArrayList]@()
                    $cmdName = $MyInvocation.InvocationName
                    $paramList = (Get-Command -Name $cmdName).Parameters
                    foreach ( $key in $paramList.Keys ) {
                        $value = (Get-Variable $key -ErrorAction SilentlyContinue).Value
                        if ( ($value -or $value -eq 0) -and ($key -ne "Id" -and $key -ne "Name" -and $key -ne "WaitForRestart") ) {
                            $SnippetArray.Add(@{$key = $value }) | Out-Null
                        }
                    }

                    foreach ($Key in $SnippetArray.Keys) {
                        $CollectorConfData = switch ($Key) {
                            "SnmpThreadPool" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "collector.snmp.threadpool" -Value $SnippetArray.$Key }
                            "SnmpPduTimeout" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "snmp.pdu.timeout" -Value $SnippetArray.$Key }
                            "ScriptThreadPool" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "collector.script.threadpool" -Value $SnippetArray.$Key }
                            "ScriptTimeout" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "collector.script.timeout" -Value $SnippetArray.$Key }
                            "BatchScriptThreadPool" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "collector.batchscript.threadpool" -Value $SnippetArray.$Key }
                            "BatchScriptTimeout" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "collector.batchscript.timeout" -Value $SnippetArray.$Key }
                            "PowerShellSPSEProcessCountMin" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "powershell.spse.process.count.min" -Value $SnippetArray.$Key }
                            "PowerShellSPSEProcessCountMax" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "powershell.spse.process.count.max" -Value $SnippetArray.$Key }
                            "NetflowEnable" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.enable" -Value $SnippetArray.$Key }
                            "NbarEnable" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.nbar.enabled" -Value $SnippetArray.$Key }
                            "NetflowPorts" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.ports" -Value $SnippetArray.$Key }
                            "SflowPorts" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.sflow.ports" -Value $SnippetArray.$Key }
                            "LMLogsSyslogEnable" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.enabled" -Value $SnippetArray.$Key }
                            "LMLogsSyslogHostnameFormat" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.hostname.format" -Value $SnippetArray.$Key }
                            "LMLogsSyslogPropertyName" { Update-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.property.name" -Value $SnippetArray.$Key }
                            default { $CollectorConfData }
                        }
                    }
                }
            }
            else {
                $CollectorConfData = $CollectorConf
            }

            #Build header and uri
            $ResourcePath = "/setting/collector/collectors/$Id/services/restart"

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
                collectorSize = $CollectorSize
                collectorConf = $CollectorConfData
                sbproxyConf   = $SbproxyConf
                watchdogConf  = $WatchdogConf
                websiteConf   = $WebsiteConf
                wrapperConf   = $WrapperConf
            }


            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set Collector Config ")) {
                Write-Warning "[WARN]: This command will restart the targeted collector on update of the configuration"
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                if ($WaitForRestart) {
                    $JobStarted = $false
                    $Tries = 0
                    while (!$JobStarted -or $Tries -eq 5) {
                        #Build header and uri
                        $ResourcePath = "/setting/collector/collectors/$Id/services/restart/$Response"
                        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                        $SubmitResponse = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                        if ($SubmitResponse.errorMessage -eq "The task is still running") {
                            Write-Information "[INFO]: The task is still running..."
                            Start-Sleep -Seconds 2
                            $Tries++
                        }
                        else {
                            $JobStarted = $true
                        }
                    }
                    return "Job status code: $($SubmitResponse.jobStatus), Job message: $($SubmitResponse.jobErrmsg)"
                }
                else {
                    return "Successfully submitted restart request(jobID:$Response) with updated configurations. Collector will restart once the request has been picked up."
                }
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
