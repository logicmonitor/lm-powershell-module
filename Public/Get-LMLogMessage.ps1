Function Get-LMLogMessage {

    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param (
        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Query')]
        [String]$Query,

        [ValidateSet("15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month", "custom")]
        [String]$Range = "15min",

        [Int]$BatchSize = 300,

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
            "custom" {
                $StartTime = ([DateTimeOffset]$($StartDate)).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($EndDate)).ToUnixTimeMilliseconds()
            }
        }

        # Build the base query
        $BaseQuery = "_partition=default"
        
        # Add additional query parameters if specified
        if ($Query) {
            $BaseQuery += " $Query"
        }


        # Build the payload
        $Data = @{
            meta = @{
                isAsync      = $Async.ToBool()
                perPageCount = $BatchSize
                queryId      = $null
                filter       = @{
                    query = $BaseQuery
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

            If(!$Async) {
                Return (Add-ObjectTypeInfo -InputObject $Response.data.byId.logs.PSObject.Properties.Value -TypeName "LogicMonitor.LMLogs")
            }

            # Handle async response
            If ($Response.meta.queryId -and $Response.meta.progress -eq 0) {
                $QueryId = $Response.meta.queryId
                $Complete = $false
                $Results = @()
                
                # Poll for completion
                While (!$Complete) {
                    Start-Sleep -Seconds 2

                    # Build the payload
                    $Data = @{
                        meta = @{
                            isAsync      = $Async.ToBool()
                            perPageCount = $BatchSize
                            queryType = "raw"
                            queryId      = $QueryId
                        }
                    }

                    $Body = $Data | ConvertTo-Json -Depth 10

                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Version 4
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
        
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body
        
                    # Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

                    $Results += $Response.data.byId.logs.PSObject.Properties.Value

                    If($Response.meta.progress -eq 1) {
                        $Complete = $true
                    }
                }
                Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LMLogs")
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
