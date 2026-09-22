<#
.SYNOPSIS
Removes a LogicMonitor resourceGroup (v4 API), including a Service
Insight/Service Template container group ("BizService" resource group).

.DESCRIPTION
Static Service Insights and Service Templates each auto-create a
SERVICE_GROUP-type resourceGroup (visible in the portal's "Services"
tree, distinct from an ordinary device group) to contain the service
and any child groups. Removing the Service Insight device
(Remove-LMServiceInsight) or Service Template
(Remove-LMDynamicServiceInsight) does not remove this container - it's left
behind. Use Get-LMServiceGroup first to confirm a group's type before
removing it here.

Named distinctly from the existing Remove-LMServiceGroup (v3
/device/groups endpoint, -Name lookup, different parameters) - this
uses the v4 /resourceGroups endpoint instead, confirmed via a HAR
capture of LogicMonitor's own UI deleting a service group. The two are
not interchangeable; this one is what's needed for SERVICE_GROUP-type
containers specifically.

.PARAMETER Id
The resourceGroups id of the group to remove.

.PARAMETER DeleteChildren
If set, also deletes all child groups/services under this one. If not
set (default), only this group itself is removed - matches
LogicMonitor's own UI choice between "Delete group" and "Delete group
and all services in the group".

.EXAMPLE
Remove-LMResourceGroup -Id 14822

.EXAMPLE
#Also remove everything nested under this group
Remove-LMResourceGroup -Id 14962 -DeleteChildren

.NOTES
You must run Connect-LMAccount with -SessionSync before running this
command - this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own UI
deleting a service group.

.INPUTS
You can pipe objects containing an Id property to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed group and a
success message confirming the removal.
#>
function Remove-LMResourceGroup {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Switch]$DeleteChildren
    )

    begin {}
    process {
        if (-not ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync")) {
            Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
            return
        }

        $Data = @{
            data = @{ allIds = @(@{ model = "resourceGroups"; id = "$Id" }) }
            meta = @{ deleteHard = $false; deleteChildren = "$($DeleteChildren.IsPresent.ToString().ToLower())" }
        } | ConvertTo-Json -Depth 10

        $ResourcePath = "/resourceGroups"
        $Message = "Id: $Id"

        if ($PSCmdlet.ShouldProcess($Message, "Remove Resource Group")) {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data | Out-Null

            return [PSCustomObject]@{
                Id      = $Id
                Message = "Successfully removed (Id: $Id)"
            }
        }
    }
    end {}
}
