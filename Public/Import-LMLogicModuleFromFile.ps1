<#
.SYNOPSIS
Imports a LogicModule into LogicMonitor using the V2 import endpoints.

.DESCRIPTION
The Import-LMLogicModuleFromFile function imports a LogicModule from a file path or file data using the new XML and JSON import endpoints. Supports various module types including datasources, configsources, eventsources, batchjobs, logsources, oids, topologysources, functions, and diagnosticsources.

.PARAMETER FilePath
The path to the file containing the LogicModule to import. The function will read the file content automatically.

.PARAMETER File
The raw file content of the LogicModule to import as a string. Use Get-Content with -Raw parameter to read file content properly (e.g., Get-Content 'file.json' -Raw).

.PARAMETER Type
The type of LogicModule. Valid values are "datasources", "configsources", "eventsources", "batchjobs", "logsources", "oids", "topologysources", "functions", "diagnosticsources". Defaults to "datasources".

.PARAMETER Format
The format of the LogicModule file. Valid values are "xml" or "json". Defaults to "json".

.PARAMETER FieldsToPreserve
Optional. Comma-separated list of fields to preserve during import. Only applies to JSON imports. Defaults to preserving none of the fields.
Valid values are "NAME", "APPLIES_TO_SCRIPT", "COLLECTION_INTERVAL", "ACTIVE_DISCOVERY_INTERVAL", "ACTIVE_DISCOVERY_FILTERS", "MODULE_GROUP", "DISPLAY_NAME", "USE_WILD_VALUE_AS_UUID", "DATAPOINT_ALERT_THRESHOLDS", "TAGS".
"NAME" will preserve the name of the LogicModule.
"APPLIES_TO_SCRIPT" will preserve the appliesToScript of the LogicModule.
"COLLECTION_INTERVAL" will preserve the collectionInterval of the LogicModule.
"ACTIVE_DISCOVERY_INTERVAL" will preserve the activeDiscoveryInterval of the LogicModule.
"ACTIVE_DISCOVERY_FILTERS" will preserve the activeDiscoveryFilters of the LogicModule.
"MODULE_GROUP" will preserve the moduleGroup of the LogicModule.
"DISPLAY_NAME" will preserve the displayName of the LogicModule.
"USE_WILD_VALUE_AS_UUID" will preserve the useWildValueAsUuid of the LogicModule.
"DATAPOINT_ALERT_THRESHOLDS" will preserve the datapointAlertThresholds of the LogicModule.
"TAGS" will preserve the tags of the LogicModule.

.PARAMETER HandleConflict
Optional. Specifies how to handle conflicts during import. Only applies to JSON imports. Defaults to "FORCE_OVERWRITE".
Valid values are "FORCE_OVERWRITE" or "ERROR".
"FORCE_OVERWRITE" will overwrite the existing LogicModule with the same name.
"ERROR" will throw an error if a conflict is found.

.EXAMPLE
#Import a datasource module from XML
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.xml" -Type "datasources" -Format "xml"

.EXAMPLE
#Import a logsource module from JSON with conflict handling
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\logsource.json" -Type "logsources" -Format "json" -HandleConflict "FORCE_OVERWRITE"

.EXAMPLE
#Import an eventsource from file data (read file content first with -Raw parameter)
$fileData = Get-Content -Path "C:\LogicModules\eventsource.xml" -Raw
Import-LMLogicModuleFromFile -File $fileData -Type "eventsources" -Format "xml"

.EXAMPLE
#Import with fields to preserve
Import-LMLogicModuleFromFile -FilePath "C:\LogicModules\datasource.json" -Type "datasources" -Format "json" -FieldsToPreserve "description,appliesTo"

.NOTES
You must run Connect-LMAccount before running this command. Requires PowerShell version 6.1 or higher.

Note: Some module types only support specific formats:
- logsources, oids, functions, diagnosticsources: JSON only
- Other types: Both XML and JSON supported

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a success message if the import is successful.
#>
function Import-LMLogicModuleFromFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = 'FilePath')]
        [String]$FilePath,

        [Parameter(Mandatory, ParameterSetName = 'File')]
        [Object]$File,

        [ValidateSet("datasources", "configsources", "eventsources", "batchjobs", "logsources", "oids", "topologysources", "functions", "diagnosticsources")]
        [String]$Type = "datasources",

        [ValidateSet("xml", "json")]
        [String]$Format = "json",

        [ValidateSet("NAME", "APPLIES_TO_SCRIPT", "COLLECTION_INTERVAL", "ACTIVE_DISCOVERY_INTERVAL", "ACTIVE_DISCOVERY_FILTERS", "MODULE_GROUP", "DISPLAY_NAME", "USE_WILD_VALUE_AS_UUID", "DATAPOINT_ALERT_THRESHOLDS", "TAGS")]
        [String]$FieldsToPreserve,

        [ValidateSet("FORCE_OVERWRITE", "ERROR")]
        [String]$HandleConflict = "FORCE_OVERWRITE"
    )

    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {

            #Check for PS version 6.1 +
            if (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
                Write-Error "This command requires PS version 6.1 or higher to run."
                return
            }

            #Validate format for specific types that only support JSON
            $JsonOnlyTypes = @("logsources", "oids", "functions", "diagnosticsources")
            if ($JsonOnlyTypes -contains $Type -and $Format -ne "json") {
                Write-Error "Module type '$Type' only supports JSON format. Please specify -Format 'json'."
                return
            }

            #Get file content from path if not given file data directly
            if ($FilePath) {
                if (!(Test-Path -Path $FilePath)) {
                    Write-Error "File not found at path: $FilePath"
                    return
                }

                $FileExtension = [IO.Path]::GetExtension($FilePath).ToLower()
                if ($FileExtension -notin @('.xml', '.json')) {
                    Write-Error "File is not a valid XML or JSON file. File extension must be .xml or .json"
                    return
                }

                #Validate format matches file extension
                $ExpectedExtension = ".$Format"
                if ($FileExtension -ne $ExpectedExtension) {
                    Write-Warning "File extension '$FileExtension' does not match specified format '$Format'. Using format: $Format"
                }

                $File = Get-Content $FilePath -Raw
            }

            #Build resource path based on type and format
            $ResourcePath = "/setting/$Type/import$Format"
            
            #Build query parameters if provided (only for JSON imports)
            $QueryParams = ""
            if ($Format -eq "json") {
                $QueryParamsList = @()
                
                if ($FieldsToPreserve) {
                    $QueryParamsList += "fieldsToPreserve=$([System.Web.HttpUtility]::UrlEncode($FieldsToPreserve))"
                }
                
                if ($HandleConflict) {
                    $QueryParamsList += "handleConflict=$([System.Web.HttpUtility]::UrlEncode($HandleConflict))"
                }
                
                if ($QueryParamsList.Count -gt 0) {
                    $QueryParams = "?" + ($QueryParamsList -join "&")
                }
            }

            #Build header and uri
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $File
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $File

            #Issue request
            try {
                # Create a temporary file with the correct extension for the upload
                $TempFile = [System.IO.Path]::GetTempFileName()
                $TempFileWithExtension = [System.IO.Path]::ChangeExtension($TempFile, $Format)
                
                # Remove the temp file without extension and use the one with extension
                if (Test-Path $TempFile) {
                    Remove-Item $TempFile -Force
                }
                
                # Write the file content to temp file
                Set-Content -Path $TempFileWithExtension -Value $File -NoNewline
                
                try {
                    # Use the file path for the form upload
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Form @{file = Get-Item $TempFileWithExtension }
                    
                    if ($Response) {
                        return "Successfully imported LogicModule of type: $Type (format: $Format)"
                    }
                }
                finally {
                    # Clean up temp file
                    if (Test-Path $TempFileWithExtension) {
                        Remove-Item $TempFileWithExtension -Force
                    }
                }
            }
            catch {
                Write-Error "Failed to import LogicModule: $_"
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}

