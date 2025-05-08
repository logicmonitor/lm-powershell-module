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
Function Get-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
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
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/device/groups"

            #Initalize vars
            $QueryParams = ""
            $Count = 0
            $Done = $false
            $Results = @()

            #Loop through requests 
            While (!$Done) {
                #Build query params
                Switch ($PSCmdlet.ParameterSetName) {
                    "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                    "Id" { $resourcePath += "/$Id" }
                    "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                    "Filter" {
                        #List of allowed filter props
                        $PropList = @()
                        $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                    }
                    "FilterWizard" {
                        $PropList = @()
                        $Filter = Build-LMFilter -PassThru
                        $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                        $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
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
                        Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
            Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroup" )
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
