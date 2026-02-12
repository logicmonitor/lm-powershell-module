<#
.SYNOPSIS
Retrieves devices belonging to a LogicMonitor device group.

.DESCRIPTION
The Get-LMDeviceGroupDevice function retrieves all devices that belong to a specific device group. It supports retrieving devices from subgroups and can filter the results.

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
Get-LMDeviceGroupDevice -Id 123

.EXAMPLE
#Retrieve devices including subgroups
Get-LMDeviceGroupDevice -Name "Production Servers" -IncludeSubGroups $true

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
            $Ids += Get-NestedDeviceGroup -Ids @($Id)
        }
        #Add in oringal Id to our list
        $Ids += $Id

        #Our return object
        $Results = @()

        foreach ($i in $Ids) {
            $ResourcePath = "/device/groups/$i/devices"

            $GroupResults = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
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

                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                if ($null -eq $Response) {
                    return $null
                }

                return $Response
            }

            if ($null -ne $GroupResults) {
                $Results += $GroupResults
            }
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
