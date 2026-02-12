<#
.SYNOPSIS
Retrieves service member information from LogicMonitor.

.DESCRIPTION
The Get-LMServiceMember function retrieves service member information from LogicMonitor based on specified parameters. It can return a single service member by ID or multiple service members based on name, display name, filter, or filter wizard. It also supports delta tracking for monitoring changes.

.PARAMETER Id
The ID of the service to retrieve members from. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the service to retrieve members from. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the service to retrieve members from. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a service member by ID
Get-LMServiceMember -Id 123

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You can pipe LogicMonitor.Device objects to this command.

.OUTPUTS
Returns LogicMonitor.ServiceMember objects.
#>
function Get-LMServiceMember {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    param (
        [Parameter(ParameterSetName = 'Id', Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'DisplayName', Mandatory)]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Name', Mandatory)]
        [String]$Name,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup Id via Name
            if ($Name) {
                $LookupResult = (Get-LMService -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup Id via DisplayName
            if ($DisplayName) {
                $LookupResult = (Get-LMService -DisplayName $DisplayName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/service/members"

            $SingleObjectWhenNotPaged = $false
            $CallerPSCmdlet = $PSCmdlet

            $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
                param($Offset, $PageSize)

                $RequestResourcePath = $ResourcePath
                $QueryParams = "?size=$PageSize&offset=$Offset"

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

            return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ServiceMember" )
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
