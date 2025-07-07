<#
.SYNOPSIS
Retrieves audit logs from LogicMonitor.

.DESCRIPTION
The Get-LMAuditLogs function retrieves audit logs from LogicMonitor based on the specified parameters. It supports retrieving logs by ID, by date range, or by applying filters. The function can retrieve up to 10000 logs in a single query.

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
Get-LMAuditLogs -StartDate (Get-Date).AddDays(-7)

.EXAMPLE
#Search for specific audit logs
Get-LMAuditLogs -SearchString "login" -StartDate (Get-Date).AddDays(-30)

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

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()
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

        #Loop through requests
        while (!$Done) {
            #Build query params
            switch ($PSCmdlet.ParameterSetName) {
                "Range" { $QueryParams = "?filter=happenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"%2C_all~`"*$SearchString*`"&size=$BatchSize&offset=$Count&sort=+happenedOn" }
                "Id" { $resourcePath += "/$Id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+happenedOn"
                }
            }
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if ($PSCmdlet.ParameterSetName -eq "Id") {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AuditLog" )
            }
            #Check result size and if needed loop again
            else {
                [Int]$Total = $Response.Total
                [Int]$Count += ($Response.Items | Measure-Object).Count
                $Results += $Response.Items
                if ($Count -ge $QueryLimit) {
                    $Done = $true
                    Write-Warning "[WARN]: Reached $QueryLimit record query limitation for this endpoint"
                }
                elseif ($Count -ge $Total -and $Total -ge 0) {
                    $Done = $true
                }
            }

        }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AuditLog" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
