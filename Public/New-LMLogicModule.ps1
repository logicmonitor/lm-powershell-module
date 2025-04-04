<#
.SYNOPSIS
Creates a new Logic Module in LogicMonitor.

.DESCRIPTION
The New-LMLogicModule function creates a new Logic Module in LogicMonitor. It supports various types of modules including datasources, property rules, topology sources, event sources, log sources, and config sources.

.PARAMETER LogicModule
A PSCustomObject containing the Logic Module configuration. Must follow the schema model defined in LogicMonitor's API documentation.

.PARAMETER Type
The type of Logic Module to create. Valid values are: datasources, propertyrules, topologysources, eventsources, logsources, configsources

.EXAMPLE
$config = @{
    name = "MyLogicModule"
    # Additional configuration properties
}
New-LMLogicModule -LogicModule $config -Type "datasources"

.NOTES
You must run Connect-LMAccount before running this command.
For Logic Module schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/Datasources/addDatasourceById

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor object of the appropriate type based on the Type parameter: LogicMonitor.Datasource, LogicMonitor.PropertySource, LogicMonitor.TopologySource, LogicMonitor.EventSource, LogicMonitor.LogSource, LogicMonitor.ConfigSource
#>

Function New-LMLogicModule {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory)]
        [PSCustomObject]$LogicModule, #follow the schema model listed here: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/Datasources/addDatasourceById,

        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "topologysources", "eventsources","logsources","configsources")]
        [String]$Type
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
                    
            #Build header and uri
            $ResourcePath = "/setting/$Type"
            
            $Message = "LogicModule Name: $($LogicModule.name) | Type: $Type"

            Switch ($Type) {
                "datasources" {
                    $ObjectType = "LogicMonitor.Datasource"
                }
                "propertyrules" {
                    $ObjectType = "LogicMonitor.PropertySource"
                }
                "topologysources" {
                    $ObjectType = "LogicMonitor.Topologysource"
                }
                "eventsources" {
                    $ObjectType = "LogicMonitor.EventSource"
                }
                "logsources" {
                    $ObjectType = "LogicMonitor.Logsource"
                }
                "configsources" {
                    $ObjectType = "LogicMonitor.ConfigSource"
                }
            }

            Try {
                $Data = $LogicModule

                $Data = ($Data | ConvertTo-Json -Depth 10)

                If ($PSCmdlet.ShouldProcess($Message, "New LogicModule")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName $ObjectType )
                }
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
    End {}
}
