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
