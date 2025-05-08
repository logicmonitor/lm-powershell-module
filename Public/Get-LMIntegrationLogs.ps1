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
Get-LMIntegrationLogs

.EXAMPLE
#Retrieve logs with a specific search string and date range
Get-LMIntegrationLogs -SearchString "error" -StartDate (Get-Date).AddDays(-7)

.NOTES
You must run Connect-LMAccount before running this command. There is a 10,000 record query limitation for this endpoint.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.IntegrationLog objects.
#>

Function Get-LMIntegrationLogs {

    [CmdletBinding(DefaultParameterSetName = 'Range')]
    Param (
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
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/integrations/auditlogs"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()
        $QueryLimit = 10000 #API limit to how many results can be returned

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            If ($PSCmdlet.ParameterSetName -ne "Id") {
                Write-Warning "[WARN]: No start date specified, defaulting to last 30 days" 
            }
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddDays(-30)).ToUnixTimeSeconds()
        }
        Else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "Range" { $QueryParams = "?filter=successfulResults%3A%22false%22%2CfailedResults%3A%22false%22%2ChappenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"%2C_all~`"*$SearchString*`"&size=$BatchSize&offset=$Count&sort=+happenedOnMs" }
                "Id" { $resourcePath += "/$Id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+happenedOnMs"
                }
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.IntegrationLog" )
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $QueryLimit) {
                        $Done = $true
                        Write-Warning "[WARN]: Reached $QueryLimit record query limitation for this endpoint" 
                    }
                    Elseif ($Count -ge $Total -and $Total -ge 0) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.IntegrationLog" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
