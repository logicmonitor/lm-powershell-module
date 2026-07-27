<#
.SYNOPSIS
Retrieves the status of a LogicMonitor report execution task.

.DESCRIPTION
Get-LMReportExecutionTask fetches information about a previously triggered report execution task.
Supply the report identifier (ID or name) along with the task ID returned from
Invoke-LMReportExecution to check completion status or retrieve the result URL.

.PARAMETER ReportId
The ID of the report whose execution task should be retrieved.

.PARAMETER ReportName
The name of the report whose execution task should be retrieved.

.PARAMETER TaskId
The execution task identifier returned when the report was triggered.

.EXAMPLE
Invoke-LMReportExecution -Id 42 | Select-Object -ExpandProperty taskId | Get-LMReportExecutionTask -ReportId 42

Gets the execution status for the specified report/task combination.

.EXAMPLE
$task = Invoke-LMReportExecution -Name "Monthly Availability"
Get-LMReportExecutionTask -ReportName "Monthly Availability" -TaskId $task.taskId

Checks the task status for the report by name.

.NOTES
You must run Connect-LMAccount before running this command.
#>
function Get-LMReportExecutionTask {

    [CmdletBinding(DefaultParameterSetName = 'ReportId')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'ReportId')]
        [Int]$ReportId,

        [Parameter(Mandatory, ParameterSetName = 'ReportName')]
        [String]$ReportName,

        [Parameter(Mandatory)]
        [String]$TaskId
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    $resolvedReportId = $null

    switch ($PSCmdlet.ParameterSetName) {
        'ReportId' {
            $resolvedReportId = $ReportId
        }
        'ReportName' {
            $lookup = Get-LMReport -Name $ReportName
            if (Test-LookupResult -Result $lookup.Id -LookupString $ReportName) {
                return
            }
            $resolvedReportId = $lookup.Id
        }
    }

    $resourcePath = "/report/reports/$resolvedReportId/tasks/$TaskId"
    $headers = New-LMHeader -Auth $Script:LMAuth -Method 'GET' -ResourcePath $resourcePath
    $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $resourcePath

    Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation

    $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'GET' -Headers $headers[0] -WebSession $headers[1]

    return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.ReportExecutionTask')
}

