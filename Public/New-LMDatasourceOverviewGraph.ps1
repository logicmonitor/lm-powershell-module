<#
.SYNOPSIS
Creates a new datasource overview graph in LogicMonitor.

.DESCRIPTION
The New-LMDatasourceOverviewGraph function creates a new overview graph for a specified datasource in LogicMonitor.

.PARAMETER RawObject
The raw object representing the graph configuration. Use Get-LMDatasourceOverviewGraph to see the expected format.

.PARAMETER DatasourceId
The ID of the datasource for which to create the overview graph. Required for dsId parameter set.

.PARAMETER DatasourceName
The name of the datasource for which to create the overview graph. Required for dsName parameter set.

.EXAMPLE
#Create overview graph using datasource ID
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceId 123

.EXAMPLE
#Create overview graph using datasource name
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceName "MyDatasource"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DatasourceGraph object.
#>
Function New-LMDatasourceOverviewGraph {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $RawObject,

        [Parameter(Mandatory, ParameterSetName = 'dsId')]
        $DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'dsName')]
        $DatasourceName

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($DataSourceName) {
            $LookupResult = (Get-LMDatasource -Name $DataSourceName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DataSourceName) {
                Return
            }
            $DatasourceId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/setting/datasources/$DatasourceId/ographs"

        Try {
            $Data = ($RawObject | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DatasourceGraph" )
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
