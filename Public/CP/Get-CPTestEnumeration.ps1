<#
.SYNOPSIS
Retrieves Catchpoint test enumerations.

.DESCRIPTION
Get-CPTestEnumeration returns name/ID enumerations used to create and update
tests via GET /v4/Tests/enumeration. When -Include is omitted, all
enumerations are returned.

.PARAMETER Include
One or more enumeration sections to return. When omitted, all sections are returned.

.EXAMPLE
Get-CPTestEnumeration

.EXAMPLE
Get-CPTestEnumeration -Include DisplayTestType, DisplayMonitorType

.NOTES
You must run Connect-CPAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a Catchpoint.Test.Enumeration object.
#>
function Get-CPTestEnumeration {
    [CmdletBinding()]
    param(
        [ValidateSet(
            'DisplayTestType',
            'AnalyticsMetric',
            'DomainStatus',
            'DisplayMonitorType',
            'WinHttpMethod',
            'WebRequestPostDataFormat',
            'UserAgentType',
            'ApiTransactionScriptType',
            'DnsQueryType',
            'TestAction',
            'SettingsType',
            'AuthenticationMethodType',
            'PasswordStatusType',
            'WebRequestHeaderType',
            'RecipientType',
            'AlertInstructionType',
            'NodeThresholdType',
            'BreakdownDimension',
            'ReminderFrequency',
            'AlertTriggerType',
            'OperatorType',
            'TestReportMetricDataType',
            'AlertGroupItemFilterType',
            'DnsTraceType',
            'AlertHistoricalTimeThreshold',
            'AlertTimeThresholdInterval',
            'NotificationType',
            'ReportAlertType',
            'ReportAlertSubtype',
            'InsightType',
            'InsightSourceType',
            'InsightContentType',
            'DisplayTestFrequency',
            'NodeDistribution',
            'SyntheticNetworkType',
            'NetworkType',
            'DomainSchedule',
            'TestFlag',
            'BandwidthThrottling',
            'SelfZoneMatchingOptions',
            'ObjectType',
            'ApplicationVersionType'
        )]
        [String[]]$Include
    )

    if (-not (Test-CPAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    $query = @{}
    foreach ($name in $Include) {
        $query[$name.Substring(0, 1).ToLowerInvariant() + $name.Substring(1)] = $true
    }

    return Invoke-CPApiRequest -ResourcePath '/v4/Tests/enumeration' -Method GET -QueryParameters $query `
        -TypeName 'Catchpoint.Test.Enumeration' -CallerPSCmdlet $PSCmdlet -Command $MyInvocation
}
