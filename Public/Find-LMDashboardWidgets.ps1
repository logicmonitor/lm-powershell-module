<#
.SYNOPSIS
Find list of dashboard widgets containing mention of specified datasources

.DESCRIPTION
Find list of dashboard widgets containing mention of specified datasources

.EXAMPLE
Find-LMDashboardWidgets -DatasourceNames @("SNMP_NETWORK_INTERFACES","VMWARE_VCETNER_VM_PERFORMANCE")

.NOTES
Created groups will be placed in a main group called Azure Resources by Subscription in the parent group specified by the -ParentGroupId parameter

.INPUTS
DatasourceNames in an array. You can also pipe datasource names to this widget.

#>
function Find-LMDashboardWidget {
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Alias("DatasourceName")]
        [String[]]$DatasourceNames,

        [String]$GroupPathSearchString = "*"
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($(Get-LMAccountStatus).Valid) {
            $Results = New-Object System.Collections.ArrayList
            $Dashboards = Get-LMDashboard | Where-Object { $_.groupFullPath -like "$GroupPathSearchString" }

            $i = 0
            $DashCount = ($Dashboards | Measure-Object).Count
            foreach ($Dashboard in $Dashboards) {
                Write-Progress -Activity "Processing Dashboard: $($Dashboard.name)" -Status "$([Math]::Floor($($i/$DashCount*100)))% Completed" -PercentComplete $($i / $DashCount * 100) -Id 0
                $Widgets = Get-LMDashboardWidget -DashboardId $Dashboard.Id

                $GraphWidgets = $Widgets | Where-Object { $_.type -eq "cgraph" }
                if ($GraphWidgets.graphInfo.datapoints.dataSourceFullName) { $GraphWidgetsFiltered = $GraphWidgets.graphInfo.datapoints | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                $BigNumberWidgets = $Widgets | Where-Object { $_.type -eq "bigNumber" }
                if ($BigNumberWidgets.bigNumberInfo.dataPoints.dataSourceFullName) { $BigNumberWidgetsFiltered = $BigNumberWidgets.bigNumberInfo.dataPoints | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                $PieWidgets = $Widgets | Where-Object { $_.type -eq "pieChart" }
                if ($PieWidgets.pieChartInfo.dataPoints.dataSourceFullName) { $PieWidgetsFiltered = $PieWidgets.pieChartInfo.dataPoints | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                $TableWidgets = $Widgets | Where-Object { $_.type -eq "dynamicTable" }
                if ($TableWidgets.dataSourceFullName) { $TableWidgetsFiltered = $TableWidgets | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                $SLAWidgets = $Widgets | Where-Object { $_.type -eq "deviceSLA" }
                if ($SLAWidgets.metrics.dataSourceFullName) { $SLAWidgetsFiltered = $SLAWidgets.metrics | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                $NOCWidgets = $Widgets | Where-Object { $_.type -eq "noc" }
                if ($NOCWidgets.items.dataSourceDisplayName) { $NOCWidgetsFiltered = $NOCWidgets.items | Where-Object { $DatasourceNames -contains $_.dataSourceDisplayName.Replace("\", "") } }

                $GaugeWidgets = $Widgets | Where-Object { $_.type -eq "gauge" }
                if ($GaugeWidgets.dataPoint.dataSourceFullName) { $GaugeWidgetsFiltered = $GaugeWidgets.dataPoint | Where-Object { $DatasourceNames -contains $_.dataSourceFullName.Split("(")[-1].Replace(")", "") } }

                if ($GraphWidgetsFiltered) {
                    $GraphWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "cgraph"
                                widgetId           = ($GraphWidgets | Where-Object { $_.graphInfo.datapoints -eq $RefObj }).Id
                                widgetName         = ($GraphWidgets | Where-Object { $_.graphInfo.datapoints -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($BigNumberWidgetsFiltered) {
                    $BigNumberWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "bigNumber"
                                widgetId           = ($BigNumberWidgets | Where-Object { $_.bigNumberInfo.dataPoints -eq $RefObj }).Id
                                widgetName         = ($BigNumberWidgets | Where-Object { $_.bigNumberInfo.dataPoints -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($PieWidgetsFiltered) {
                    $PieWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "pieChart"
                                widgetId           = ($PieWidgets | Where-Object { $_.pieChartInfo.dataPoints -eq $RefObj }).Id
                                widgetName         = ($PieWidgets | Where-Object { $_.pieChartInfo.dataPoints -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($TableWidgetsFiltered) {
                    $TableWidgetsFiltered | ForEach-Object { $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = "N/A"
                                dataPointName      = "N/A"
                                widgetType         = "dynamicTable"
                                widgetId           = $_.id
                                widgetName         = $_.name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($SLAWidgetsFiltered) {
                    $SLAWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "deviceSLA"
                                widgetId           = ($SLAWidgets | Where-Object { $_.metrics -eq $RefObj }).Id
                                widgetName         = ($SLAWidgets | Where-Object { $_.metrics -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($NOCWidgetsFiltered) {
                    $NOCWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "noc"
                                widgetId           = ($NOCWidgets | Where-Object { $_.items -eq $RefObj }).Id
                                widgetName         = ($NOCWidgets | Where-Object { $_.items -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }

                if ($GaugeWidgetsFiltered) {
                    $GaugeWidgetsFiltered | ForEach-Object { $RefObj = $_ ; $Results.Add([PSCustomObject]@{
                                dataSourceId       = $_.dataSourceId
                                dataSourceFullName = $_.dataSourceFullName
                                dataPointId        = $_.dataPointId
                                dataPointName      = $_.dataPointName
                                widgetType         = "gauge"
                                widgetId           = ($GaugeWidgets | Where-Object { $_.dataPoint -eq $RefObj }).Id
                                widgetName         = ($GaugeWidgets | Where-Object { $_.dataPoint -eq $RefObj }).Name
                                dashboardId        = $Dashboard.id
                                dashboardName      = $Dashboard.name
                                dashboardPath      = $Dashboard.groupFullPath
                            }) | Out-Null }
                }
                $i++
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.WidgetSearch" )
    }
}