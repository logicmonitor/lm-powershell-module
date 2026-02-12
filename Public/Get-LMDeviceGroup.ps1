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

            $ParameterSetName = $PSCmdlet.ParameterSetName
            $SingleObjectWhenNotPaged = $ParameterSetName -eq "Id"
            $CallerPSCmdlet = $PSCmdlet

            $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
                param($Offset, $PageSize)

                $RequestResourcePath = $ResourcePath
                $QueryParams = ""

                switch ($ParameterSetName) {
                    "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id" }
                    "Id" { $RequestResourcePath = "$ResourcePath/$Id" }
                    "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$PageSize&offset=$Offset&sort=+id" }
                    "Filter" {
                        $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                    }
                    "FilterWizard" {
                        $Filter = Build-LMFilter -PassThru -ResourcePath $ResourcePath
                        $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                        $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
                    }
                }

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                if ($null -eq $Response) { return }

                return $Response
            }

            if ($null -eq $Results) {
                return
            }

            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroup" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
