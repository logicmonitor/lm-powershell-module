<#
.SYNOPSIS
Retrieves integration audit logs from LogicMonitor.

.DESCRIPTION
The Get-LMIntegrationLogs function retrieves integration audit logs from LogicMonitor. It supports retrieving logs by ID, date range, search string, or filter criteria.

.PARAMETER Id
The specific integration log ID to retrieve.

.PARAMETER SearchString
A string to search for within the integration logs.

.PARAMETER StartDate
The start date for retrieving logs. Defaults to 30 days ago if not specified.

.PARAMETER EndDate
The end date for retrieving logs. Defaults to current time if not specified.

.PARAMETER Filter
A filter object to apply when retrieving logs.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve logs for the last 30 days
Get-LMIntegrationLog

.EXAMPLE
#Retrieve logs with a specific search string and date range
Get-LMIntegrationLog -SearchString "error" -StartDate (Get-Date).AddDays(-7)

.NOTES
You must run Connect-LMAccount before running this command. There is a 10,000 record query limitation for this endpoint.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.IntegrationLog objects.
#>

function Get-LMIntegrationLog {

    [CmdletBinding(DefaultParameterSetName = 'Range')]
    param (
        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [Parameter(ParameterSetName = 'Range')]
        [String]$SearchString,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/integrations/auditlogs"

        $QueryLimit = 10000 #API limit to how many results can be returned

        #Convert to epoch, if not set use defaults
        if (!$StartDate) {
            if ($PSCmdlet.ParameterSetName -ne "Id") {
                Write-Warning "[WARN]: No start date specified, defaulting to last 30 days"
            }
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddDays(-30)).ToUnixTimeSeconds()
        }
        else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        if (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -MaxItems $QueryLimit -MaxItemsWarningMessage "[WARN]: Reached $QueryLimit record query limitation for this endpoint" -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "Range" { $QueryParams = "?filter=successfulResults%3A%22false%22%2CfailedResults%3A%22false%22%2ChappenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"%2C_all~`"*$SearchString*`"&size=$PageSize&offset=$Offset&sort=+happenedOnMs" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+happenedOnMs"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.IntegrationLog" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
