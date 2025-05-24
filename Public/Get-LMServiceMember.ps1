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
Function Get-LMServiceMember {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
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
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Id via Name
            If ($Name) {
                $LookupResult = (Get-LMService -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup Id via DisplayName
            If ($DisplayName) {
                $LookupResult = (Get-LMService -DisplayName $DisplayName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/service/members"

            #Initalize vars
            $QueryParams = ""
            $Count = 0
            $Done = $false
            $Results = @()

            #Loop through requests 
            While (!$Done) {
                Try {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams
                
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
                Catch [Exception] {
                    $Proceed = Resolve-LMException -LMException $PSItem
                    If (!$Proceed) {
                        Return
                    }
                }
            }
            Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ServiceMember" )
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
