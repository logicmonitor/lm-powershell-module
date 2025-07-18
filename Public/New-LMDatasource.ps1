<#
.SYNOPSIS
Creates a new LogicMonitor datasource.

.DESCRIPTION
The New-LMDatasource function creates a new datasource in LogicMonitor using a provided datasource configuration object.

.PARAMETER Datasource
A PSCustomObject containing the datasource configuration. Must follow the schema model defined in LogicMonitor's API documentation.

.EXAMPLE
#Create a new datasource
$config = @{
    name = "MyDatasource"
    # Additional configuration properties
}
New-LMDatasource -Datasource $config

.NOTES
You must run Connect-LMAccount before running this command.
For datasource schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/Datasources/addDatasourceById

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.Datasource object.
#>

function New-LMDatasource {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Datasource #follow the schema model listed here: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/Datasources/addDatasourceById
    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/datasources"

            $Message = "LogicModule Name: $($Datasource.name)"

            
            $Data = $Datasource

            $Data = ($Data | ConvertTo-Json -Depth 10)

            if ($PSCmdlet.ShouldProcess($Message, "New Datasource")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
