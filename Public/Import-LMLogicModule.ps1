<#
.SYNOPSIS
Imports a LogicModule into LogicMonitor.

.DESCRIPTION
The Import-LMLogicModule function imports a LogicModule from a file path or file data. Supports various module types including datasource, propertyrules, eventsource, topologysource, configsource, logsource, functions, and oids.

.PARAMETER FilePath
The path to the file containing the LogicModule to import.

.PARAMETER File
The file data of the LogicModule to import.

.PARAMETER Type
The type of LogicModule. Valid values are "datasource", "propertyrules", "eventsource", "topologysource", "configsource", "logsource", "functions", "oids". Defaults to "datasource".

.PARAMETER ForceOverwrite
Whether to overwrite an existing LogicModule with the same name. Defaults to $false.

.EXAMPLE
#Import a datasource module
Import-LMLogicModule -FilePath "C:\LogicModules\datasource.xml" -Type "datasource" -ForceOverwrite $true

.EXAMPLE
#Import a property rules module
Import-LMLogicModule -File $fileData -Type "propertyrules"

.NOTES
You must run Connect-LMAccount before running this command. Requires PowerShell version 6.1 or higher.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the import is successful.
#>
Function Import-LMLogicModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'FilePath')]
        [String]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'File')]
        [Object]$File,
        
        [ValidateSet("datasource", "propertyrules", "eventsource", "topologysource", "configsource","logsource","functions","oids")]
        [String]$Type = "datasource",

        [Boolean]$ForceOverwrite = $false #Only used for datasource, propertyrules, eventsource, topologysource, configsource, logsource
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Get file content from path if not given file data directly
            If ($FilePath) {

                #Check for PS version 6.1 +
                If (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
                    Write-Error "This command requires PS version 6.1 or higher to run."
                    return
                }

                If (!(Test-Path -Path $FilePath) -and ((!([IO.Path]::GetExtension($FilePath) -eq '.xml')) -or (!([IO.Path]::GetExtension($FilePath) -eq '.json')))) {
                    Write-Error "File not found or is not a valid xml/json file, check file path and try again"
                    Return
                }

                $File = Get-Content $FilePath -Raw
            }
            
            #Build header and uri
            Switch ($Type) {
                "oids" {
                    $ResourcePath = "/setting/oids"
                    $QueryParams = ""

                    $JsonFile = $File | ConvertFrom-Json
                    
                    $File = @{
                        oid = $JsonFile.oid
                        categories = $JsonFile.categories
                    } | ConvertTo-Json -Depth 10

                }
                "functions" {
                    $ResourcePath = "/setting/functions"
                    $QueryParams = ""
                    
                    $JsonFile = $File | ConvertFrom-Json

                    $File = @{
                        name = $JsonFile.name
                        description = $JsonFile.description
                        code = $JsonFile.code
                    } | ConvertTo-Json -Depth 10

                }
                default {
                    $ResourcePath = "/setting/logicmodules/importfile"
                    $QueryParams = "?type=$Type&forceOverwrite=$ForceOverwrite"
                }
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $File
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $File

                #Issue request
                If ($Type -eq "oids" -or $Type -eq "functions") {
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $File
                    Return "Successfully imported LogicModule of type: $($Type)"
                }
                Else {
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Form @{file = $File }
                    Return "Successfully imported LogicModule of type: $($Response.items.type)"
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