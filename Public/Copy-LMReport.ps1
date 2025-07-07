<#
.SYNOPSIS
Creates a copy of a LogicMonitor report.

.DESCRIPTION
The Copy-LMReport function creates a new report based on an existing report's configuration. It allows you to specify a new name, description, and parent group while maintaining other settings from the source report.

.PARAMETER Name
The name for the new report. This parameter is mandatory.

.PARAMETER Description
An optional description for the new report.

.PARAMETER ParentGroupId
The ID of the parent group for the new report.

.PARAMETER ReportObject
The source report object to copy settings from. This parameter is mandatory.

.EXAMPLE
#Copy a report with basic settings
Copy-LMReport -Name "New Report" -ReportObject $reportObject

.EXAMPLE
#Copy a report with all optional parameters
Copy-LMReport -Name "New Report" -Description "New report description" -ParentGroupId 12345 -ReportObject $reportObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the newly created report object.
#>
function Copy-LMReport {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [String]$ParentGroupId,

        [Parameter(Mandatory)]
        $ReportObject
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Replace name and description if present
        $ReportObject.name = $Name
        if ($Description) { $ReportObject.description = $Description }
        if ($ParentGroupId) { $ReportObject.groupId = $ParentGroupId }

        #Build header and uri
        $ResourcePath = "/report/reports"

        $Data = ($ReportObject | ConvertTo-Json)

        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

        return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Report" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
