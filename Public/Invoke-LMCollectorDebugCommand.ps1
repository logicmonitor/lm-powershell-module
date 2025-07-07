<#
.SYNOPSIS
Executes debug commands on a LogicMonitor collector.

.DESCRIPTION
The Invoke-LMCollectorDebugCommand function allows execution of debug, PowerShell, or Groovy commands on a specified LogicMonitor collector.

.PARAMETER Id
The ID of the collector. Required for Id parameter sets.

.PARAMETER Name
The name of the collector. Required for Name parameter sets.

.PARAMETER DebugCommand
The debug command to execute. Required for Debug parameter sets.

.PARAMETER PoshCommand
The PowerShell command to execute. Required for Posh parameter sets.

.PARAMETER GroovyCommand
The Groovy command to execute. Required for Groovy parameter sets.

.PARAMETER CommandHostName
The hostname context for the command execution.

.PARAMETER CommandWildValue
The wild value context for the command execution.

.PARAMETER IncludeResult
Switch to wait for and include command execution results.

.EXAMPLE
#Execute a debug command
Invoke-LMCollectorDebugCommand -Id 123 -DebugCommand "!account" -IncludeResult

.EXAMPLE
#Execute a PowerShell command
Invoke-LMCollectorDebugCommand -Name "Collector1" -PoshCommand "Get-Process"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns command execution results if IncludeResult is specified.
#>
function Invoke-LMCollectorDebugCommand {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Id-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Id-Groovy')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Groovy')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Debug')]
        [String]$DebugCommand,

        [Parameter(Mandatory, ParameterSetName = 'Id-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Posh')]
        [String]$PoshCommand,

        [Parameter(Mandatory, ParameterSetName = 'Id-Groovy')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Groovy')]
        [String]$GroovyCommand,

        [String]$CommandHostName,

        [String]$CommandWildValue,

        [Switch]$IncludeResult
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Cannot indent or it breaks here-string format
            $DefaultGroovy = @"
!groovy
import com.santaba.agent.collector3.CollectorDb;
def hostProps = [:];
def instanceProps = [:];
Try {
    hostProps = CollectorDb.getInstance().getHost("$CommandHostName").getProperties();
    instanceProps["wildvalue"] = "$CommandWildValue";
    }
catch(Exception e) {

};

$GroovyCommand
"@

            #Cannot indent or it breaks here-string format
            $DefaultPosh = @"
!posh

$PoshCommand
"@

            #Lookup device name
            if ($Name) {
                $LookupResult = (Get-LMCollector -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/debug"

            #Build query params
            $QueryParams = "?collectorId=$Id"

            #Construct Body
            switch -Wildcard ($PSCmdlet.ParameterSetName) {
                "*Debug" { $Data = @{ cmdline = $DebugCommand } }
                "*Posh" { $Data = @{ cmdline = $DefaultPosh } }
                "*Groovy" { $Data = @{ cmdline = $DefaultGroovy } }
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            if ($IncludeResult) {
                $CommandCompleted = $false
                while (!$CommandCompleted) {
                    $CommandResult = Get-LMCollectorDebugResult -SessionId $Response.sessionId -Id $Id
                    if ($CommandResult.errorMessage -eq "Agent has fetched the task, waiting for response") {
                        Write-Information "[INFO]: Agent has fetched the task, waiting for response..."
                        Start-Sleep -Seconds 5
                    }
                    else {
                        $CommandCompleted = $false
                        return $CommandResult
                    }
                }
            }
            else {
                $Result = [PSCustomObject]@{
                    SessionId   = $Response.sessionId
                    CollectorId = $Id
                    Message     = "Submitted debug command task under session id $($Response.sessionId) for collector id: $($Id). Use Get-LMCollectorDebugResult to retrieve response or resubmit request with -IncludeResult"
                }
                return $Result
            }
            return
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}