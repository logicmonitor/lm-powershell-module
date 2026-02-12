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
function Get-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
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
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/admins/apitokens"

        #Initialize vars
        $BearerParam = ""
        if ($Type -eq "Bearer") {
            $BearerParam = "&type=bearer"
        }

        $ParameterSetName = $PSCmdlet.ParameterSetName
        $SingleObjectWhenNotPaged = $false

        $ExtractResponse = {
            param($r)
            if ($null -eq $r) { return $null }
            if (-not (Test-LMResponseHasPagination -Response $r) -and $r.items) { return $r.items }
            return $r
        }

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -SingleObjectWhenNotPaged:$SingleObjectWhenNotPaged -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = ""

            switch ($ParameterSetName) {
                "All" { $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id$BearerParam" }
                "Id" { $QueryParams = "?filter=id:$Id&size=$PageSize&offset=$Offset&sort=+id$BearerParam" }
                "AccessId" { $QueryParams = "?filter=accessId:`"$AccessId`"&size=$PageSize&offset=$Offset&sort=+id$BearerParam" }
                "AdminId" {
                    $RequestResourcePath = "/setting/admins/$AdminId/apitokens"
                    $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id$BearerParam"
                }
                "Filter" {
                    $ValidFilter = Format-LMFilter -Filter $Filter -ResourcePath $ResourcePath
                    $QueryParams = "?filter=$ValidFilter&size=$PageSize&offset=$Offset&sort=+id$BearerParam"
                }
            }

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) { return }

            return $Response
        } -ExtractResponse $ExtractResponse

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.APIToken" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
