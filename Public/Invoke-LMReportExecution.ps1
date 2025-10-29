<#
.SYNOPSIS
Triggers the execution of a LogicMonitor report.

.DESCRIPTION
Invoke-LMReportExecution starts an on-demand run of a LogicMonitor report. The report can be
identified by ID or name. Optional parameters allow impersonating another admin or overriding the
email recipients for the generated output.

.PARAMETER Id
The ID of the report to execute.

.PARAMETER Name
The name of the report to execute.

.PARAMETER WithAdminId
The admin ID to impersonate when generating the report. Defaults to the current user when omitted.

.PARAMETER ReceiveEmails
One or more email addresses (comma-separated) that should receive the generated report.

.EXAMPLE
Invoke-LMReportExecution -Id 42

Starts an immediate execution of the report with ID 42 using the current user's context.

.EXAMPLE
Invoke-LMReportExecution -Name "Monthly Availability" -WithAdminId 101 -ReceiveEmails "ops@example.com"

Runs the "Monthly Availability" report as admin ID 101 and emails the results to ops@example.com.

.NOTES
You must run Connect-LMAccount before running this command.
#>
function Invoke-LMReportExecution {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Int]$WithAdminId = 0,

        [String]$ReceiveEmails
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    $reportId = $null

    switch ($PSCmdlet.ParameterSetName) {
        'Id' {
            $reportId = $Id
        }
        'Name' {
            $lookup = Get-LMReport -Name $Name
            if (Test-LookupResult -Result $lookup.Id -LookupString $Name) {
                return
            }
            $reportId = $lookup.Id
        }
    }

    $resourcePath = "/report/reports/$reportId/executions"

    $Data = @{
        withAdminId = $WithAdminId
        receiveEmails = $ReceiveEmails
    }

    $body = Format-LMData -Data $Data -UserSpecifiedKeys $PSBoundParameters.Keys

    $headers = New-LMHeader -Auth $Script:LMAuth -Method 'POST' -ResourcePath $resourcePath -Data $body

    $uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $resourcePath

    Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $body

    $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method 'POST' -Headers $headers[0] -WebSession $headers[1] -Body $body

    return (Add-ObjectTypeInfo -InputObject $response -TypeName 'LogicMonitor.ReportExecutionTask')
}

