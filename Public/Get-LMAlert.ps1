<#
.SYNOPSIS
Retrieves alerts from LogicMonitor.

.DESCRIPTION
The Get-LMAlert function retrieves alerts from LogicMonitor based on specified criteria. It supports filtering by date range, severity, type, and cleared status.

.PARAMETER StartDate
The start date for retrieving alerts. Defaults to 0 (beginning of time).

.PARAMETER EndDate
The end date for retrieving alerts. Defaults to current time.

.PARAMETER Id
The specific alert ID to retrieve. This parameter is part of a mutually exclusive parameter set.

.PARAMETER Severity
The severity level to filter alerts by. Valid values are "*", "Warning", "Error", "Critical". Defaults to "*".

.PARAMETER Type
The type of alerts to retrieve. Valid values are "*", "websiteAlert", "dataSourceAlert", "eventAlert", "logAlert". Defaults to "*".

.PARAMETER ClearedAlerts
Whether to include cleared alerts. Defaults to $false.

.PARAMETER Filter
A filter object to apply when retrieving alerts. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface. Part of a mutually exclusive parameter set.

.PARAMETER CustomColumns
Array of custom column names to include in the results.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.PARAMETER Sort
The field to sort results by. Defaults to "+resourceId".

.EXAMPLE
#Retrieve alerts from the last 7 days
Get-LMAlert -StartDate (Get-Date).AddDays(-7) -Severity "Error"

.EXAMPLE
#Retrieve a specific alert with custom columns
Get-LMAlert -Id 12345 -CustomColumns "Column1","Column2"

.NOTES
You must run Connect-LMAccount before running this command. Maximum of 10000 alerts can be retrieved in a single query.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Alert objects.
#>
function Get-LMAlert {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String]$Id,

        [ValidateSet("*", "Warning", "Error", "Critical")]
        [String]$Severity = "*",

        [ValidateSet("*", "websiteAlert", "dataSourceAlert", "eventAlert", "logAlert")]
        [String]$Type = "*",

        [Boolean]$ClearedAlerts = $false,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [String[]]$CustomColumns,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000,

        [String]$Sort = "+resourceId"
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/alert/alerts"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()
        $QueryLimit = 10000 #API limit to how many results can be returned


        #Convert to epoch, if not set use defaults
        if (!$StartDate) {
            [int]$StartDate = 0
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
                "Id" { $resourcePath += "/$Id" }
                "Range" { $QueryParams = "?filter=startEpoch>:`"$StartDate`",startEpoch<:`"$EndDate`",rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=$Sort" }
                "All" { $QueryParams = "?filter=rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=$Sort" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=$Sort"
                }
                "FilterWizard" {
                    $PropList = @()
                    $Filter = Build-LMFilter -PassThru
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=$Sort"
                }
            }

            #Check if we need to add customColumns
            if ($CustomColumns) {
                $FormatedColumns = @()
                foreach ($Column in $CustomColumns) {
                    $FormatedColumns += [System.Web.HTTPUtility]::UrlEncode($Column)
                }

                if ($QueryParams) {
                    $QueryParams += "&customColumns=$($FormatedColumns -join ",")"
                }
                else {
                    $QueryParams = "?customColumns=$($FormatedColumns -join",")"
                }
            }

            try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                #Stop looping if single device, no need to continue
                if ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Alert" )
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
            catch {
                return
            }
        }

        # Return $Results
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Alert" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
