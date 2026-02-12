<#
.SYNOPSIS
Retrieves alert settings for a specific LogicMonitor device.

.DESCRIPTION
The Get-LMDeviceAlertSetting function retrieves the alert configuration settings for a specific device in LogicMonitor. The device can be identified by either ID or name, and the results can be filtered using custom criteria.

.PARAMETER Id
The ID of the device to retrieve alert settings for. This parameter is mandatory when using the Id parameter set and can accept pipeline input.

.PARAMETER Name
The name of the device to retrieve alert settings for. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving alert settings. This parameter is optional.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve alert settings for a device by ID
Get-LMDeviceAlertSetting -Id 123

.EXAMPLE
#Retrieve alert settings for a device by name
Get-LMDeviceAlertSetting -Name "Production-Server"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
System.Int32. The device ID can be piped to this function.

.OUTPUTS
Returns LogicMonitor.AlertSetting objects.
#>

function Get-LMDeviceAlertSetting {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            if ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/alertsettings"

            $SingleObjectWhenNotPaged = $false

            $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
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

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #If the API call failed (for example, resource not found), stop processing.
                if ($null -eq $Response) {
                    return
                }

                return $Response
            }

            if ($null -eq $Results) {
                return
            }

            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AlertSetting" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
