<#
.SYNOPSIS
Retrieves audit logs from LogicMonitor.

.DESCRIPTION
The Get-LMAuditLog function retrieves audit logs from LogicMonitor based on the specified parameters. It supports retrieving logs by ID, by date range, or by applying filters. The function can retrieve up to 10000 logs in a single query.

.PARAMETER Id
The ID of the specific audit log to retrieve. This parameter is part of a mutually exclusive parameter set.

.PARAMETER SearchString
A string to filter audit logs by. Only logs containing this string will be returned.

.PARAMETER StartDate
The start date for retrieving audit logs. Defaults to 30 days ago if not specified.

.PARAMETER EndDate
The end date for retrieving audit logs. Defaults to current time if not specified.

.PARAMETER Filter
A filter object to apply when retrieving audit logs. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve audit logs from the last week
Get-LMAuditLog -StartDate (Get-Date).AddDays(-7)

.EXAMPLE
#Search for specific audit logs
Get-LMAuditLog -SearchString "login" -StartDate (Get-Date).AddDays(-30)

.NOTES
You must run Connect-LMAccount before running this command. Maximum of 10000 logs can be retrieved in a single query.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.AuditLog objects.
#>
function Get-LMAuditLog {

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
        $ResourcePath = "/setting/accesslogs"

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
        $CommandInvocation = $MyInvocation

        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -MaxItems $QueryLimit -MaxItemsWarningMessage "[WARN]: Reached $QueryLimit record query limitation for this endpoint" -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "Range" { $QueryParams = "?filter=happenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"%2C_all~`"*$SearchString*`"&size=$PageSize&offset=$Offset&sort=+happenedOn" }
                "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+happenedOn"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AuditLog" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
