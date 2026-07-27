<#
.SYNOPSIS
Retrieves log alert processors from LogicMonitor.

.DESCRIPTION
The Get-LMLogAlert function retrieves log alert processor configurations from LogicMonitor.
It can retrieve all processors, a specific processor by ID or name, or filter by parent pipeline ID.

.PARAMETER Id
The ID of the specific log alert processor to retrieve.

.PARAMETER Name
The name of the specific log alert processor to retrieve.

.PARAMETER PipelineId
The ID of the parent log alert group (pipeline) to filter processors by.

.EXAMPLE
Get-LMLogAlert

.EXAMPLE
Get-LMLogAlert -PipelineId 10

.EXAMPLE
Get-LMLogAlert -Name "High Error Rate"

.NOTES
You must run Connect-LMAccount before running this command.
Log alerts are processor rules within a log pipeline. This cmdlet does not retrieve active log alert instances;
use Get-LMAlert -Type logAlert for active alerts.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogAlert objects.
#>
function Get-LMLogAlert {
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Parameters are referenced inside pagination/cursor script blocks')]
    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'PipelineId')]
        [Int]$PipelineId
    )

    if ($Script:LMAuth.Valid) {
        $ResourcePath = "/logpipelines/processors"
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
        elseif ($ParameterSetName -eq 'PipelineId') {
            $Results = @($Results | Where-Object { $_.pipelineId -eq $PipelineId })
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LogAlert")
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
