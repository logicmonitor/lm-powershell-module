<#
.SYNOPSIS
Retrieves data for LogicMonitor device instances.

.DESCRIPTION
The Get-LMDeviceInstanceData function retrieves monitoring data for specified device instances in LogicMonitor. It supports data aggregation and time range filtering, with a maximum timeframe of 24 hours.

.PARAMETER StartDate
The start date for the data retrieval. Defaults to 24 hours ago if not specified.

.PARAMETER EndDate
The end date for the data retrieval. Defaults to current time if not specified.

.PARAMETER Ids
An array of device instance IDs for which to retrieve data. This parameter is mandatory and can be specified using the Id alias.

.PARAMETER AggregationType
The type of aggregation to apply to the data. Valid values are "first", "last", "min", "max", "sum", "average", "none". Defaults to "none".

.PARAMETER Period
The period for data aggregation. Defaults to 1 as this appears to be the only supported value.

.EXAMPLE
#Retrieve data for multiple instances with aggregation
Get-LMDeviceInstanceData -Ids "12345","67890" -AggregationType "average" -StartDate (Get-Date).AddHours(-12)

.EXAMPLE
#Retrieve raw data for a single instance
Get-LMDeviceInstanceData -Id "12345" -AggregationType "none"

.NOTES
You must run Connect-LMAccount before running this command. Maximum time range for data retrieval is 24 hours.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns an array of data points for the specified device instances.
#>
Function Get-LMDeviceInstanceData {

    [CmdletBinding()]
    Param (
        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Parameter(Mandatory)]
        [Alias("Id")]
        [String[]]$Ids,

        [ValidateSet("first", "last", "min", "max", "sum", "average", "none")]
        [String]$AggregationType = "none",

        [Double]$Period = 1 #Seems like the only value here is 1, so default to 1
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/device/instances/datafetch"

        #Initalize vars
        $QueryParams = ""
        $Results = @()

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddHours(-24)).ToUnixTimeSeconds()
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

        #Build query params

        $QueryParams = "?period=$Period&start=$StartDate&end=$EndDate&aggregate=$AggregationType"

        $Data = @{
            "instanceIds" = $Ids -join ","
        } | ConvertTo-Json
        
        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            $Results = $Response.Items
        }
        Catch [Exception] {
            Resolve-LMException -LMException $PSItem
        }

        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
