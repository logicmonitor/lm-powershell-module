<#
.SYNOPSIS
Gets LogicMonitor system OID mappings.

.DESCRIPTION
The Get-LMSysOIDMap function retrieves system OID mappings from LogicMonitor. It can retrieve all mappings, a specific mapping by ID or name, or filter the results.

.PARAMETER Id
Specifies the ID of a specific OID mapping to retrieve.

.PARAMETER Name 
Specifies the name of a specific OID mapping to retrieve.

.PARAMETER Filter
Specifies a filter to apply to the results.

.PARAMETER BatchSize
Specifies the number of records to retrieve per API request. Valid values are 1-1000. Default is 1000.

.EXAMPLE
#Retrieve all system OID mappings
Get-LMSysOIDMap

.EXAMPLE
#Retrieve a specific OID mapping by name
Get-LMSysOIDMap -Name "\.1\.3\.6\.1\.4\.1\.318\.1\.1\.32"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SysOIDMap objects.
#>

Function Get-LMSysOIDMap {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/oids"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.SysOIDMap")
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.SysOIDMap")
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
