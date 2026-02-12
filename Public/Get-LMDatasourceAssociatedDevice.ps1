<#
.SYNOPSIS
Retrieves devices associated with a LogicMonitor datasource.

.DESCRIPTION
The Get-LMDatasourceAssociatedDevice function retrieves all devices that are associated with a specific datasource. It can identify the datasource by ID, name, or display name.

.PARAMETER Id
The ID of the datasource to retrieve associated devices for. This parameter is mandatory when using the Id parameter set.

.PARAMETER Name
The name of the datasource to retrieve associated devices for. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the datasource to retrieve associated devices for. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving associated devices. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve devices associated with a datasource by ID
Get-LMDatasourceAssociatedDevice -Id 123

.EXAMPLE
#Retrieve devices associated with a datasource by name
Get-LMDatasourceAssociatedDevice -Name "CPU"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DatasourceDevice objects.
#>

function Get-LMDatasourceAssociatedDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        if ($Name) {
            $LookupResult = (Get-LMDatasource -Name $Name).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        if ($DisplayName) {
            $LookupResult = (Get-LMDatasource -DisplayName $DisplayName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                return
            }
            $Id = $LookupResult
        }

        $ResourcePath = "/setting/datasources/$Id/devices"
        $CommandInvocation = $MyInvocation

        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"
            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return $null }
            return $Response
        }

        if ($null -eq $Results) { return }
        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DatasourceDevice" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
