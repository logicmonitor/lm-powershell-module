<#
.SYNOPSIS
Retrieves device information from LogicMonitor.

.DESCRIPTION
The Get-LMDevice function retrieves device information from LogicMonitor based on specified parameters. It can return a single device by ID or multiple devices based on name, display name, filter, or filter wizard. It also supports delta tracking for monitoring changes.

.PARAMETER Id
The ID of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER DisplayName
The display name of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Name
The name of the device to retrieve. Part of a mutually exclusive parameter set.

.PARAMETER Filter
A filter object to apply when retrieving devices. Part of a mutually exclusive parameter set.

.PARAMETER FilterWizard
Switch to use the filter wizard interface for building the filter. Part of a mutually exclusive parameter set.

.PARAMETER Delta
Switch to return a deltaId along with the requested data for change tracking.

.PARAMETER DeltaId
The deltaId string for retrieving changes since a previous query.

.PARAMETER BatchSize
The number of results to return per request. Must be between 1 and 1000. Defaults to 1000.

.EXAMPLE
#Retrieve a device by ID
Get-LMDevice -Id 123

.EXAMPLE
#Retrieve devices with delta tracking
Get-LMDevice -Delta

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Device objects.
#>
Function Get-LMDevice {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'FilterWizard')]
        [Switch]$FilterWizard,

        [Parameter(ParameterSetName = 'Filter')]
        [Parameter(ParameterSetName = 'FilterWizard')]
        [Parameter(ParameterSetName = 'Name')]
        [Parameter(ParameterSetName = 'DisplayName')]
        [Parameter(ParameterSetName = 'All')]
        [Switch]$Delta,
        
        [Parameter(ParameterSetName = 'Delta')]
        [String]$DeltaId,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        If ($Delta -or $DeltaId) {
            $ResourcePath = "/device/devices/delta"
        }
        Else {
            $ResourcePath = "/device/devices"
        }

        #Initalize vars
        $QueryParams = ""
        $DeltaIdResponse = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Delta" { $resourcePath += "/$DeltaId" ; $QueryParams = "?size=$BatchSize&offset=$Count" }
                "Id" { $resourcePath += "/$Id" }
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
                "FilterWizard" {
                    $PropList = @()
                    $Filter = Build-LMFilter -PassThru
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    Write-Host $Filter
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }
            If ($Delta -and $DeltaIdResponse) {
                $QueryParams = $QueryParams + "&deltaId=$DeltaIdResponse"
            }
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Store delta id if delta switch is present
                If ($Response.deltaId -and !$DeltaIdResponse) {
                    $DeltaIdResponse = $Response.deltaId
                    Write-Information "[INFO]: Delta switch detected, for further queries you can use deltaId: $DeltaIdResponse to perform additional delta requests. This variable can be accessed by referencing the `$LMDeltaId " 
                    Set-Variable -Name "LMDeltaId" -Value $DeltaIdResponse -Scope global
                }

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Device" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
