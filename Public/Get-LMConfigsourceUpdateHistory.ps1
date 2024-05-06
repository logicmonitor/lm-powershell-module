<#
.SYNOPSIS
Retrieves the update history for a LogicMonitor configuration source.

.DESCRIPTION
The Get-LMConfigsourceUpdateHistory function retrieves the update history for a LogicMonitor configuration source. It can be used to get information about the updates made to a configuration source, such as the update reasons and the modules that were updated.

.PARAMETER Id
The ID of the configuration source. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the configuration source. This parameter is used to look up the ID of the configuration source. This parameter is used when using the 'Name' parameter set.

.PARAMETER DisplayName
The display name of the configuration source. This parameter is used to look up the ID of the configuration source. This parameter is used when using the 'DisplayName' parameter set.

.PARAMETER Filter
A filter object that specifies additional filtering criteria for the update history. This parameter is optional.

.PARAMETER BatchSize
The number of results to retrieve per request. The default value is 1000. This parameter is optional.

.EXAMPLE
Get-LMConfigsourceUpdateHistory -Id 1234
Retrieves the update history for the configuration source with the ID 1234.

.EXAMPLE
Get-LMConfigsourceUpdateHistory -Name "MyConfigSource"
Retrieves the update history for the configuration source with the name "MyConfigSource".

.EXAMPLE
Get-LMConfigsourceUpdateHistory -DisplayName "My Config Source"
Retrieves the update history for the configuration source with the display name "My Config Source".

#>
Function Get-LMConfigsourceUpdateHistory {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
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
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMConfigsource -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        If ($DisplayName) {
            $LookupResult = (Get-LMConfigsource -DisplayName $DisplayName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/configsources/$Id/updatereasons"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            If ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.ModuleUpdateHistory" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.ModuleUpdateHistory" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
