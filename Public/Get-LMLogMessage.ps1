<#
.SYNOPSIS
Retrieves log messages from LogicMonitor.

.DESCRIPTION
The Get-LMLogMessage function retrieves log messages from LogicMonitor based on specified time ranges or date ranges. It supports both synchronous and asynchronous queries with pagination control.

.PARAMETER StartDate
The start date for retrieving log messages. Required for Date parameter sets.

.PARAMETER EndDate
The end date for retrieving log messages. Required for Date parameter sets.

.PARAMETER Query
A query string to filter the log messages.

.PARAMETER Range
The time range for retrieving log messages. Valid values are "15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month". Defaults to "15min".

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 300. Defaults to 300.

.PARAMETER MaxPages
The maximum number of pages to retrieve in async mode. Defaults to 10.

.PARAMETER Async
Switch to enable asynchronous query mode.

.EXAMPLE
#Retrieve logs for a specific date range
Get-LMLogMessage -StartDate (Get-Date).AddDays(-1) -EndDate (Get-Date)

.EXAMPLE
#Retrieve logs asynchronously with a custom query
Get-LMLogMessage -Range "1hour" -Query "error" -Async

.NOTES
You must run Connect-LMAccount before running this command. This command is reserver for internal use only.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LMLogs objects.
#>
function Get-LMLogMessage {

    [CmdletBinding(DefaultParameterSetName = "Range-Async")]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Date-Sync')]
        [Parameter(Mandatory, ParameterSetName = 'Date-Async')]
        [Datetime]$StartDate,

        [Parameter(Mandatory, ParameterSetName = 'Date-Sync')]
        [Parameter(Mandatory, ParameterSetName = 'Date-Async')]
        [Datetime]$EndDate,

        [String]$Query,

        [Parameter(ParameterSetName = 'Range-Sync')]
        [Parameter(ParameterSetName = 'Range-Async')]
        [ValidateSet("15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month")]
        [String]$Range = "15min",

        [Int]$BatchSize = 300,

        [Parameter(ParameterSetName = 'Date-Async')]
        [Parameter(ParameterSetName = 'Range-Async')]
        [Int]$MaxPages = 10,

        [Parameter(ParameterSetName = 'Date-Async')]
        [Parameter(ParameterSetName = 'Range-Async')]
        [Switch]$Async
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid -and $Script:LMAuth.Type -eq "SessionSync") {

        #Build header and uri
        $ResourcePath = "/log/search"

        #Initialize vars
        $Results = @()

        #Convert to epoch, if not set use defaults
        $CurrentTime = Get-Date

        if ($StartDate -and $EndDate) {
            $StartTime = ([DateTimeOffset]$($StartDate)).ToUnixTimeMilliseconds()
            $EndTime = ([DateTimeOffset]$($EndDate)).ToUnixTimeMilliseconds()
        }
        else {
            switch ($Range) {
                "15min" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddMinutes(-15))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "30min" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddMinutes(-30))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "1hour" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-1))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "3hour" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-3))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "6hour" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-6))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "12hour" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-12))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "24hour" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-1))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "3day" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-3))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "7day" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-7))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
                "1month" {
                    $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-30))).ToUnixTimeMilliseconds()
                    $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
                }
            }
        }

        # Build the payload
        $Data = @{
            meta = @{
                isAsync      = $Async.ToBool()
                perPageCount = $BatchSize
                queryId      = $null
                queryType    = $null
                filter       = @{
                    query = $Query
                    range = @{
                        startAtMS = $StartTime
                        endAtMS   = $EndTime
                    }
                }
            }
        }

        $Body = $Data | ConvertTo-Json -Depth 10

        
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

        # Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

        if (!$Async) {
            if ($Response.data.byId.logs.PSObject.Properties.Value) {
                return (Add-ObjectTypeInfo -InputObject $Response.data.byId.logs.PSObject.Properties.Value -TypeName "LogicMonitor.LMLogs")
            }
            else {
                Write-Information "No results found for query ($($Query))"
                return
            }
        }

        # Handle async response
        if ($Response.meta.queryId -and $Response.meta.progress -ne 1) {
            $QueryId = $Response.meta.queryId
            $Complete = $false
            $Results = @()
            $Cursor = $null
            $Page = 0
            # Poll for completion
            while (!$Complete) {
                $CompletionPercentage = [Math]::Round($Response.meta.progress * 100, 2)
                Write-Information "Log message query ($($QueryId)) is running, this may take some time. First pass scan $CompletionPercentage% complete, working on page $($Page) of results."
                Start-Sleep -Seconds 2

                # Build the payload
                $Data = @{
                    meta = @{
                        isAsync      = $Async.ToBool()
                        perPageCount = $BatchSize
                        queryType    = "raw"
                        queryId      = $QueryId
                    }
                }
                #cursor is used to build the pagination, using the chunk path and index to build the cursor on the next bucket that needs to be scanned
                if ($Cursor) {
                    $Data.meta.cursor = $Cursor
                    $Data.meta.filter = @{
                        query = $Query
                        range = @{
                            startAtMS = $StartTime
                            endAtMS   = $EndTime
                        }
                    }
                }

                $Body = $Data | ConvertTo-Json -Depth 10

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

                # Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                if ($Response.meta.progress -eq 1) {
                    if ($Response.data.byId.logs.PSObject.Properties.Value) {
                        $Results += $Response.data.byId.logs.PSObject.Properties.Value
                        $Cursor = $Response.meta.cursor
                        $Page++
                    }
                    if ($Response.meta.isLastPage -eq $true -or $Page -ge $MaxPages) {
                        $Complete = $true
                    }
                }
            }
            if ($Results) {
                if ($Page -eq $MaxPages) {
                    Write-Information "Max pages reached, stopping query. If you need more results, try increasing the MaxPages parameter."
                }
                return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LMLogs")
            }
            else {
                Write-Information "No results found for query ($($QueryId))"
            }
        }
        else {
            Write-Error "Error getting log messages: $($Response)"
        }

    }
    else {
        Write-Error "This cmdlet is for internal use only at this time does not support LMv1 or Bearer auth. Use Connect-LMAccount to login with the correct auth type and try again"
    }
}
