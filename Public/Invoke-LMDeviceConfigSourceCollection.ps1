<#
.SYNOPSIS
Invokes configuration collection for a device datasource.

.DESCRIPTION
The Invoke-LMDeviceConfigSourceCollection function triggers configuration collection for a specified device datasource instance.

.PARAMETER DatasourceName
The name of the datasource. Required for dsName parameter sets.

.PARAMETER DatasourceId
The ID of the datasource. Required for dsId parameter sets.

.PARAMETER Id
The ID of the device. Required for Id parameter sets.

.PARAMETER Name
The name of the device. Required for Name parameter sets.

.PARAMETER HdsId
The host datasource ID. Required for HdsId parameter sets.

.PARAMETER InstanceId
The ID of the datasource instance.

.EXAMPLE
#Collect config using datasource name
Invoke-LMDeviceConfigSourceCollection -Name "Device1" -DatasourceName "Config" -InstanceId "123"

.EXAMPLE
#Collect config using datasource ID
Invoke-LMDeviceConfigSourceCollection -Id 456 -DatasourceId 789 -InstanceId "123"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the collection is scheduled successfully.
#>
function Invoke-LMDeviceConfigSourceCollection {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [String]$HdsId,

        [Parameter(Mandatory)]
        [String]$InstanceId
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Lookup Device Id
            if ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup DatasourceId
            if ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$InstanceId/config/configCollection"

            try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                return "Scheduled Config collection task for device id: $Id."
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
