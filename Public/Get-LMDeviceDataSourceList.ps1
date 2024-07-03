<#
.SYNOPSIS
Retrieves a list of device data sources from LogicMonitor.

.DESCRIPTION
The Get-LMDeviceDatasourceList function retrieves a list of device data sources from LogicMonitor based on the specified parameters. It supports filtering by device ID or device name, and allows customization of the batch size for pagination.

.PARAMETER Id
Specifies the ID of the device for which to retrieve the data sources. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the device for which to retrieve the data sources. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Filter
Specifies additional filters to apply to the data sources. This parameter accepts an object representing the filter criteria.

.PARAMETER BatchSize
Specifies the number of data sources to retrieve per batch. The default value is 1000.

.EXAMPLE
Get-LMDeviceDatasourceList -Id 1234
Retrieves the data sources for the device with ID 1234.

.EXAMPLE
Get-LMDeviceDatasourceList -Name "MyDevice"
Retrieves the data sources for the device with the name "MyDevice".

.EXAMPLE
Get-LMDeviceDatasourceList -Filter "Property -eq 'Value'"
Retrieves the data sources that match the specified filter criteria.

#>
Function Get-LMDeviceDatasourceList {
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [Alias('DeviceName')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    # Rest of the code...
}

Function Get-LMDeviceDatasourceList {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Alias('DeviceId')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [Alias('DeviceName')]
        [String]$Name,

        [Object]$Filter,

        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMDevice -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceDatasourceList" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceDatasourceList" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
