<#
.SYNOPSIS
Retrieves properties of a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupProperty function retrieves all properties associated with a specified device group in LogicMonitor. The device group can be identified by either ID or name, and the results can be filtered.

.PARAMETER Id
The ID of the device group to retrieve properties from. Required for Id parameter set.

.PARAMETER Name
The name of the device group to retrieve properties from. Required for Name parameter set.

.PARAMETER Filter
A filter object to apply when retrieving properties. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve properties by group ID
Get-LMDeviceGroupProperty -Id 123

.EXAMPLE
#Retrieve filtered properties by group name
Get-LMDeviceGroupProperty -Name "Production" -Filter $filterObject

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns property objects for the specified device group.
#>

function Get-LMDeviceGroupProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
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
        $ResourcePath = "/device/groups/$Id/properties"

        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"

            if ($Filter) {
                $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id"
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return $Results
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
