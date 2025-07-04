<#
.SYNOPSIS
Retrieves devices belonging to a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupDevices function retrieves all devices that belong to a specific device group. It supports retrieving devices from subgroups and can filter the results.

.PARAMETER Id
The ID of the device group. Required for Id parameter set.

.PARAMETER Name
The name of the device group. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving devices. This parameter is optional.

.PARAMETER IncludeSubGroups
When set to true, includes devices from all subgroups of the specified group. Defaults to false.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve devices from a group by ID
Get-LMDeviceGroupDevices -Id 123

.EXAMPLE
#Retrieve devices including subgroups
Get-LMDeviceGroupDevices -Name "Production Servers" -IncludeSubGroups $true

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Device objects.
#>

function Get-LMDeviceGroupDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [Boolean]$IncludeSubGroups = $false,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($Name) {
            $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        $Ids = @()
        if ($IncludeSubGroups) {
            $Ids += Get-NestedDeviceGroups -Ids @($Id)
        }
        #Add in oringal Id to our list
        $Ids += $Id

        #Our return object
        $Results = @()

        foreach ($i in $Ids) {

            #Build header and uri
            $ResourcePath = "/device/groups/$i/devices"

            #Initalize vars
            $QueryParams = ""
            $Count = 0
            $Done = $false

            #Loop through requests
            while (!$Done) {
                #Build query params
                $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

                if ($Filter) {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }

                try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                    #Stop looping if single device, no need to continue
                    if (![bool]$Response.psobject.Properties["total"]) {
                        $Done = $true
                        $Results += $Response
                    }
                    #Check result size and if needed loop again
                    else {
                        [Int]$Total = $Response.Total
                        [Int]$Count += ($Response.Items | Measure-Object).Count
                        $Results += $Response.Items
                        if ($Count -ge $Total) {
                            $Done = $true
                        }
                    }
                }
                catch {
                    return
                }
            }
            #Dedupe results
        }
        if ($Results) {
            $Results = ($Results | Sort-Object -Property Id -Unique)
        }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Device" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
