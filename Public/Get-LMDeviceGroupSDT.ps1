<#
.SYNOPSIS
Retrieves Scheduled Downtime (SDT) entries for a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupSDT function retrieves all active Scheduled Downtime entries for a specified device group in LogicMonitor. The device group can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device group to retrieve SDT entries from. Required for Id parameter set.

.PARAMETER Name
The name of the device group to retrieve SDT entries from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving SDT entries. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve SDT entries by group ID
Get-LMDeviceGroupSDT -Id 123

.EXAMPLE
#Retrieve filtered SDT entries by group name
Get-LMDeviceGroupSDT -Name "Production" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT objects.
#>

Function Get-LMDeviceGroupSDT {

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
        $ResourcePath = "/device/groups/$Id/sdts"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.SDT" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.SDT" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
