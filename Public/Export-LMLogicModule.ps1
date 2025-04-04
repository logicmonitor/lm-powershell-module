<#
.SYNOPSIS
Exports LogicMonitor LogicModules for backup or transfer.

.DESCRIPTION
The Export-LMLogicModule function exports LogicModules from LogicMonitor. It supports exporting various types of modules including datasources, property rules, event sources, and more.

.PARAMETER LogicModuleId
The ID of the LogicModule to export. This parameter is mandatory when using the Id parameter set.

.PARAMETER LogicModuleName
The name of the LogicModule to export. This parameter is mandatory when using the Name parameter set.

.PARAMETER Type
The type of LogicModule to export. Valid values are: "datasources", "propertyrules", "eventsources", "topologysources", "configsources", "logsources", "functions", "oids".

.PARAMETER DownloadPath
The path where the exported LogicModule will be saved. Defaults to current directory.

.EXAMPLE
#Export a LogicModule by ID
Export-LMLogicModule -LogicModuleId 1907 -Type "eventsources"

.EXAMPLE
#Export a LogicModule by name
Export-LMLogicModule -LogicModuleName "SNMP_Network_Interfaces" -Type "datasources"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the export is completed successfully.
#>
Function Export-LMLogicModule {

    [CmdletBinding(DefaultParameterSetName = "Id")]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [Int]$LogicModuleId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$LogicModuleName,

        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources","logsources", "functions", "oids")]
        [String]$Type,

        [String]$DownloadPath = (Get-Location).Path
    )
    Begin {

    }
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            $LogicModuleInfo = @()
            $QueryParams = ""
            $ExportPath = ""

            If ($LogicModuleName) {
                Switch ($Type) {
                    "datasources" {
                        $LogicModuleInfo = Get-LMDataSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "propertyrules" {
                        #Not implemented yet
                        $LogicModuleInfo = Get-LMPropertysource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "eventsources" {
                        $LogicModuleInfo = Get-LMEventSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "topologysources" {
                        $LogicModuleInfo = Get-LMTopologySource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "configsources" {
                        $LogicModuleInfo = Get-LMConfigSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "logsources" {
                        $LogicModuleInfo = Get-LMLogSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "functions" {
                        $LogicModuleInfo = Get-LMAppliesToFunction -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "oids" {
                        $LogicModuleInfo = Get-LMSysOIDMap -Name $LogicModuleName
                        $FileName = $LogicModuleInfo.categories -replace ',', '_' -replace ' ', ''
                        $ExportPath = $DownloadPath + "\$FileName.json"
                        $QueryParams = "?format=file&v=3"
                    }
                }
                #Verify our query only returned one result
                If (Test-LookupResult -Result $LogicModuleInfo.Id -LookupString $LogicModuleName) {
                    return
                }
                $LogicModuleId = $LogicModuleInfo.Id
            }
            Else {
                Switch ($Type) {
                    "datasources" {
                        $LogicModuleInfo = Get-LMDatasource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "propertyrules" {
                        #Not implemented yet
                        $LogicModuleInfo = Get-LMPropertysource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "eventsources" {
                        $LogicModuleInfo = Get-LMEventSource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "topologysources" {
                        $LogicModuleInfo = Get-LMTopologySource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "configsources" {
                        $LogicModuleInfo = Get-LMConfigSource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "logsources" {
                        $LogicModuleInfo = Get-LMLogSource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "functions" {
                        $LogicModuleInfo = Get-LMAppliesToFunction -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "oids" {
                        $LogicModuleInfo = Get-LMSysOIDMap -Id $LogicModuleId
                        $FileName = $LogicModuleInfo.categories -replace ',', '_' -replace ' ', ''
                        $ExportPath = $DownloadPath + "\$FileName.json"
                        $QueryParams = "?format=file&v=3"
                    }
                }
            }

            
            #Build header and uri
            $ResourcePath = "/setting/$Type/$LogicModuleId"
            
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1] -OutFile $ExportPath

                Return "Successfully downloaded LogicModule id ($LogicModuleId) of type $Type"
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
