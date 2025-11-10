<#
.SYNOPSIS
Retrieves device group information from LogicMonitor.

.DESCRIPTION
The Get-LMDeviceGroup function retrieves device group information from a connected LogicMonitor portal. It supports retrieving groups by ID, name (including wildcards), or using custom filters.

.PARAMETER Id
The ID of the device group to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the device group to retrieve. Supports wildcard input such as "* - Servers". Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving device groups. Can include multiple conditions combined as AND operations. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve all device groups
Get-LMDeviceGroup

.EXAMPLE
#Retrieve a specific device group by name with wildcard
Get-LMDeviceGroup -Name "* - Servers"

.EXAMPLE
#Retrieve device groups using a filter
Get-LMDeviceGroup -Filter @{parentId=1;disableAlerting=$false}

.NOTES
You must run Connect-LMAccount before running this command. When using filters, consult the LM API docs for allowed filter fields.

.INPUTS
System.Int32. The device group ID can be piped to this function.

.OUTPUTS
Returns LogicMonitor.DeviceGroup objects.
#>
function Get-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the FilterWizard to work')]

    param (
        [Parameter(ParameterSetName = 'Id', ValueFromPipeline)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/device/groups"

            #Initalize vars
            $QueryParams = ""
            $Count = 0
            $Done = $false
            $Results = @()

            #Loop through requests
            while (!$Done) {
                #Build query params
                switch ($PSCmdlet.ParameterSetName) {
                    "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                    "Id" { $resourcePath += "/$Id" }
                    "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                    "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                    "FilterWizard" {
                    $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                }
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams



                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                if ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroup" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
