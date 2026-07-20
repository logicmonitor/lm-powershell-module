<#
.SYNOPSIS
Retrieves log alert groups from LogicMonitor.

.DESCRIPTION
The Get-LMLogAlertGroup function retrieves log alert group (log pipeline) configurations from LogicMonitor.
It can retrieve all groups, a specific group by ID or name, or filter results client-side by name.

.PARAMETER Id
The ID of the specific log alert group to retrieve.

.PARAMETER Name
The name of the specific log alert group to retrieve.

.EXAMPLE
Get-LMLogAlertGroup

.EXAMPLE
Get-LMLogAlertGroup -Name "Production Logs"

.NOTES
You must run Connect-LMAccount before running this command.
Log alert groups manage log pipeline configuration. This cmdlet does not retrieve active log alert instances;
use Get-LMAlert -Type logAlert for active alerts.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogAlertGroup objects.
#>
function Get-LMLogAlertGroup {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameters are referenced inside pagination/cursor script blocks')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name
    )

    if ($Script:LMAuth.Valid) {
        $ResourcePath = "/logpipelines"
        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            if ($ParameterSetName -eq "Id") {
                $RequestResourcePath = "$ResourcePath/$Id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }

        if ($ParameterSetName -eq 'Name') {
            $Results = @($Results | Where-Object { $_.name -eq $Name })
            if (Test-LookupResult -Result $Results -LookupString $Name) {
                return
            }
            $Results = $Results[0]
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LogAlertGroup")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
