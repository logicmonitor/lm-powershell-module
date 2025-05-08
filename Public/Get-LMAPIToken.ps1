<#
.SYNOPSIS
Retrieves API tokens from LogicMonitor.

.DESCRIPTION
The Get-LMAPIToken function retrieves API tokens from LogicMonitor based on specified criteria. It can return tokens by admin ID, token ID, access ID, or using filters.

.PARAMETER AdminId
The ID of the admin to retrieve tokens for. Part of a mutually exclusive parameter set.

.PARAMETER Id
The ID of the specific API token to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER AccessId
The access ID of the specific API token to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving tokens. Part of a mutually exclusive parameter set.

.PARAMETER Type
The type of token to retrieve. Valid values are "LMv1", "Bearer", "*". Defaults to "*".

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve tokens for a specific admin
Get-LMAPIToken -AdminId 1234

.EXAMPLE
#Retrieve a specific token by ID
Get-LMAPIToken -Id 5678

.EXAMPLE
#Retrieve bearer tokens only
Get-LMAPIToken -Type "Bearer"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.APIToken objects.
#>
Function Get-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'AdminId')]
        [Int]$AdminId,

        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'AccessId')]
        [String]$AccessId,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateSet("LMv1", "Bearer", "*")]
        [String]$Type = "*",

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/admins/apitokens"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        If ($Type -eq "Bearer") {
            $BearerParam = "&type=bearer"
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "Id" { $QueryParams = "?filter=id:$Id&size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "AccessId" { $QueryParams = "?filter=accessId:`"$AccessId`"&size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "AdminId" { $resourcePath = "/setting/admins/$AdminId/apitokens$BearerParam" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id$BearerParam"
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
                    Return (Add-ObjectTypeInfo -InputObject $Response.items -TypeName "LogicMonitor.APIToken" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.APIToken" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
