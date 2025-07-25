<#
.SYNOPSIS
Retrieves a list of datasources for a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupDatasourceList function retrieves all datasources associated with a specific device group. The device group can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device group. Required for Id parameter set.

.PARAMETER Name
The name of the device group. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving datasources. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve datasources by device group ID
Get-LMDeviceGroupDatasourceList -Id 123

.EXAMPLE
#Retrieve datasources by device group name with filter
Get-LMDeviceGroupDatasourceList -Name "Production Servers" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DeviceGroupDatasource objects.
#>

function Get-LMDeviceGroupDatasourceList {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

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

        #Build header and uri
        $ResourcePath = "/device/groups/$Id/datasources"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

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
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

            #Stop looping if single device, no need to continue
            if (![bool]$Response.psobject.Properties["total"]) {
                $Done = $true
                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroupDatasource" )
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
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroupDatasource" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
