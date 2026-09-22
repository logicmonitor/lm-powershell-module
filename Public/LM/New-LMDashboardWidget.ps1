<#
.SYNOPSIS
Creates a new LogicMonitor dashboard widget.

.DESCRIPTION
The New-LMDashboardWidget function creates a widget on a dashboard from
a raw widget configuration object. Widget shape varies significantly by
type (cgraph, dynamicTable, bignumber, noc, deviceSLA, etc.) - this
cmdlet does not attempt to normalize that; pass the full object matching
what Get-LMDashboardWidget returns for the type you want (minus id/
lastUpdatedOn/lastUpdatedBy/userPermission, which the API sets).

.PARAMETER Widget
A PSCustomObject or hashtable containing the widget configuration,
matching the shape LogicMonitor's API expects for that widget's type
(see an existing widget of the same type via Get-LMDashboardWidget for
the exact shape to copy).

.NOTES
Validation constraints found by trial and error (the API rejects
these, not silently-wrong widgets):
- cgraph: graphInfo.scaleUnit must be 1000 or 1024, not 1. graphInfo
  also needs a value for both topX and aggregate - omitting/mismatching
  these fails with "no topX and aggregate specified." Confirmed working
  shape not yet fully pinned down for a from-scratch cgraph; easiest
  path is copying an existing cgraph widget's full JSON via
  Get-LMDashboardWidget and editing dataPoints/appliesTo, rather than
  building graphInfo by hand.
- Column-level colorThresholds (dynamicTable): must be PRESENT on every
  column (omitting the key entirely fails with "column<N>: Miss
  colorThresholds" - confirmed via the persistent test suite). An empty
  array (colorThresholds = @()) is accepted (confirmed against a real
  reference widget, APC UPS Batteries id 20, which also uses []). A
  bare-number array (e.g. @(2,5) for warn/critical values) was tried
  and rejected with a deserialization error - the non-empty structured
  shape is not yet reverse-engineered, but colorThresholds=@() always
  works as a safe default.
- bigNumber counters/bigNumberItems and dynamicTable columns/rows
  (confirmed working shapes) are documented in
  Custom/DataSources/compound_service_template/README.md in the
  Logic.Monitor.SE workspace this was built alongside.

.EXAMPLE
$widget = @{
    name = "My Table"
    type = "dynamicTable"
    dashboardId = 123
    dataSourceId = 456
    columns = @(...)
    rows = @(@{label="##RESOURCENAME##"; groupFullPath="*"; deviceDisplayName="*"; instanceName="*"})
}
New-LMDashboardWidget -Widget $widget

.NOTES
You must run Connect-LMAccount before running this command.

.OUTPUTS
Returns the created widget object.
#>
function New-LMDashboardWidget {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [Object]$Widget
    )

    begin {}
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        $ResourcePath = "/dashboard/widgets"
        $Data = ($Widget | ConvertTo-Json -Depth 10)
        $Message = "Widget: $($Widget.name)"

        if ($PSCmdlet.ShouldProcess($Message, "Create Dashboard Widget")) {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DashboardWidget")
        }
    }
    end {}
}
