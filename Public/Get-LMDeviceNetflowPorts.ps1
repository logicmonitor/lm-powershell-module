<#
.SYNOPSIS
Retrieves Netflow port data for a LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceNetflowPorts function retrieves Netflow port information for a specified device. It supports time range filtering and can identify the device by either ID or name.

.PARAMETER Id
The ID of the device to retrieve Netflow ports from. Required for Id parameter set.

.PARAMETER Name
The name of the device to retrieve Netflow ports from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving ports. This parameter is optional.

.PARAMETER StartDate
The start date for retrieving Netflow data. Defaults to 24 hours ago if not specified.

.PARAMETER EndDate
The end date for retrieving Netflow data. Defaults to current time if not specified.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve Netflow ports by device ID
Get-LMDeviceNetflowPorts -Id 123

.EXAMPLE
#Retrieve Netflow ports with date range
Get-LMDeviceNetflowPorts -Name "Router1" -StartDate (Get-Date).AddDays(-7)

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Netflow port objects.
#>

Function Get-LMDeviceNetflowPorts {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Convert to epoch, if not set use defaults (24 hours ago)
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
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/ports"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=-usage&start=$StartDate&end=$EndDate"

            If ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=-usage"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return $Response
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
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
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
