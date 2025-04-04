<#
.SYNOPSIS
Retrieves alerts for a specific LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceAlerts function retrieves all alerts associated with a specific device in LogicMonitor. The device can be identified by either ID or name, and the results can be filtered using custom criteria.

.PARAMETER Id
The ID of the device to retrieve alerts for. This parameter is mandatory when using the Id parameter set and can accept pipeline input.

.PARAMETER Name
The name of the device to retrieve alerts for. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving alerts. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve alerts for a device by ID
Get-LMDeviceAlerts -Id 123

.EXAMPLE
#Retrieve alerts for a device by name with filtering
Get-LMDeviceAlerts -Name "Production-Server" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
System.Int32. The device ID can be piped to this function.

.OUTPUTS
Returns LogicMonitor.Alert objects.
#>

Function Get-LMDeviceAlerts {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
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
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/alerts"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Alert" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Alert" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
