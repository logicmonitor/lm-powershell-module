<#
.SYNOPSIS
Retrieves Scheduled Downtime (SDT) history for a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupSDTHistory function retrieves the historical Scheduled Downtime entries for a specified device group in LogicMonitor. The device group can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device group to retrieve SDT history from. Required for Id parameter set.

.PARAMETER Name
The name of the device group to retrieve SDT history from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving SDT history. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve SDT history by group ID
Get-LMDeviceGroupSDTHistory -Id 123

.EXAMPLE
#Retrieve filtered SDT history by group name
Get-LMDeviceGroupSDTHistory -Name "Production" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns SDT history objects for the specified device group.
#>

Function Get-LMDeviceGroupSDTHistory {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/groups/$Id/historysdts"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            If ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
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
