<#
.SYNOPSIS
Retrieves full detail for a LogicMonitor resource group, including
its type (e.g. SERVICE_GROUP for a Service Insight/Service Template
container vs. an ordinary device group).

.DESCRIPTION
Get-LMDeviceGroup (v3 API) doesn't expose a group's `type` or
`recordTypeName` fields, which is how a Service Insight or Service
Template's auto-created container group ("BizService", shown as a
SERVICE_GROUP in the portal's "Services" tree) is distinguished from
an ordinary device group. Get-LMServiceGroup fetches that detail via
the v4 /resourceGroups/filter endpoint.

Removing a Service Insight (Remove-LMServiceInsight) or Service
Template (Remove-LMDynamicServiceInsight) does not remove this container
group - it's left behind separately. Use Remove-LMResourceGroup to
clean it up once identified here.

.PARAMETER Id
The resourceGroups id to fetch.

.EXAMPLE
Get-LMServiceGroup -Id 14822

.NOTES
You must run Connect-LMAccount with -SessionSync before running this
command - this endpoint does not support LMv1 or Bearer auth.
Request shape confirmed via a HAR capture of LogicMonitor's own UI
deleting a service group.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the raw resourceGroups object for the given id (not wrapped
in a LogicMonitor.* type, since its shape differs substantially from
Get-LMDeviceGroup's).
#>
function Get-LMServiceGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Id
    )

    begin {}
    process {
        if (-not ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync")) {
            Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
            return
        }

        $Body = @{
            meta = @{
                selectedId = @{ model = "resourceGroups"; id = "$Id" }
                filters    = @{ filterType = "FILTER_CATEGORICAL_MODEL_TYPE"; resourceGroups = @{ dynamic = @() } }
                columns    = @()
                paging     = @{ perPageCount = 1; pageOffsetCount = 0 }
            }
        } | ConvertTo-Json -Depth 10

        $ResourcePath = "/resourceGroups/filter"
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

        return $Response.data.byId.resourceGroups.$Id
    }
    end {}
}
