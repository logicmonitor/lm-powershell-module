Function Get-LMLogMessage {

    [CmdletBinding(DefaultParameterSetName = "Range-Async")]
    Param (
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
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/log/search"

        #Initialize vars
        $Results = @()

        #Convert to epoch, if not set use defaults
        $CurrentTime = Get-Date

        If ($StartDate -and $EndDate) {
            $StartTime = ([DateTimeOffset]$($StartDate)).ToUnixTimeMilliseconds()
            $EndTime = ([DateTimeOffset]$($EndDate)).ToUnixTimeMilliseconds()
        }
        Else {
            Switch ($Range) {
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

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

            # Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

            If (!$Async) {
                If ($Response.data.byId.logs.PSObject.Properties.Value) {
                    Return (Add-ObjectTypeInfo -InputObject $Response.data.byId.logs.PSObject.Properties.Value -TypeName "LogicMonitor.LMLogs")
                }
                Else {
                    Write-Information "No results found for query ($($Query))"
                    Return
                }
            }

            # Handle async response
            If ($Response.meta.queryId -and $Response.meta.progress -ne 1) {
                $QueryId = $Response.meta.queryId
                $Complete = $false
                $Results = @()
                $Cursor = $null
                $Page = 0
                # Poll for completion
                While (!$Complete) {
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
                    If ($Cursor) {
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
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
        
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body
        
                    # Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                    If ($Response.meta.progress -eq 1) {
                        If ($Response.data.byId.logs.PSObject.Properties.Value) {
                            $Results += $Response.data.byId.logs.PSObject.Properties.Value
                            $Cursor = $Response.meta.cursor
                            $Page++
                        }
                        If ($Response.meta.isLastPage -eq $true -or $Page -ge $MaxPages) {
                            $Complete = $true
                        }
                    }
                }
                If ($Results) {
                    If ($Page -eq $MaxPages) {
                        Write-Information "Max pages reached, stopping query. If you need more results, try increasing the MaxPages parameter."
                    }
                    Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LMLogs")
                }
                Else {
                    Write-Information "No results found for query ($($QueryId))"
                }
            }
            Else {
                Write-Error "Error getting log messages: $($Response)"
            }
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
