<#
.SYNOPSIS
Retrieves datasources from LogicMonitor.

.DESCRIPTION
The Get-LMDatasource function retrieves datasource information from LogicMonitor. It can return datasources by ID, name, display name, or using filters.

.PARAMETER Id
The ID of the datasource to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the datasource to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the datasource to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving datasources. Part of a mutually exclusive parameter set.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a datasource by ID
Get-LMDatasource -Id 123

.EXAMPLE
#Retrieve a datasource by display name
Get-LMDatasource -DisplayName "CPU Usage"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Datasource objects.
#>
Function Get-LMDatasource {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/datasources"

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
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource")
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Datasource")
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
