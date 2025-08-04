<#
.SYNOPSIS
Retrieves metadata about LogicMonitor Logic Modules.

.DESCRIPTION
The Get-LMLogicModuleMetadata function retrieves metadata about Logic Modules from LogicMonitor. It supports filtering by module type, tag, status, author portal name, and whether the module is in use.

.PARAMETER isInUse
Filter results by whether the Logic Module is currently in use.

.PARAMETER Type
Filter results by Logic Module type. Valid values are: DATASOURCE, PROPERTYSOURCE, CONFIGSOURCE, EVENTSOURCE, TOPOLOGYSOURCE, SNMP_SYSOID_MAP, LOGSOURCE, APPLIESTO_FUNCTION.

.PARAMETER Tag
Filter results by Logic Module tag.

.PARAMETER Status
Filter results by Logic Module status. Valid values are: CORE, COMMUNITY, SECURITY_REVIEW, BETA, *.

.PARAMETER AuthorPortalName
Filter results by the portal name of the Logic Module author.

.PARAMETER Name
Filter results by Logic Module name.

.EXAMPLE
# Get all Logic Module metadata
Get-LMLogicModuleMetadata

.EXAMPLE
# Get metadata for only DataSource type Logic Modules
Get-LMLogicModuleMetadata -Type DATASOURCE

.EXAMPLE
# Get metadata for Logic Modules that are currently in use
Get-LMLogicModuleMetadata -isInUse $true

.NOTES
You must run Connect-LMAccount before running this command. Not every LogicModule type uses the isInUse parameter so be sure to check the documentation for the specific LogicModule type you are interested in.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogicModuleMetadata objects.
#>


function Get-LMLogicModuleMetadata {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [Boolean]$isInUse,

        [Parameter(Mandatory = $false)]
        [ValidateSet("DATASOURCE", "PROPERTYSOURCE", "CONFIGSOURCE", "DIAGNOSTICSOURCE", "EVENTSOURCE", "TOPOLOGYSOURCE", "SNMP_SYSOID_MAP", "LOGSOURCE", "APPLIESTO_FUNCTION")]
        [String]$Type,

        [Parameter(Mandatory = $false)]
        [String]$Tag,

        [Parameter(Mandatory = $false)]
        [ValidateSet("CORE", "COMMUNITY", "SECURITY_REVIEW", "BETA", "*")] #Not all types have statuses
        [String]$Status,

        [Parameter(Mandatory = $false)]
        [String]$AuthorPortalName,

        [Parameter(Mandatory = $false)]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/setting/logicmodules/metadata"

        #Initalize vars
        $QueryParams = ""

        
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams


        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

        #Issue request
        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

        #Perform filtering since this endpoint does not support filtering
        $Response = $Response | Where-Object {
            ($null -eq $isInUse -or $_.isInUse -eq $isInUse) -and
            ([string]::IsNullOrEmpty($Type) -or $_.type -eq $Type) -and
            ([string]::IsNullOrEmpty($Tag) -or $_.tags -contains $Tag) -and
            ([string]::IsNullOrEmpty($Name) -or $_.name -like "*$Name*") -and
            ([string]::IsNullOrEmpty($Status) -or $_.status -like "*$Status*") -and
            ([string]::IsNullOrEmpty($AuthorPortalName) -or $_.authorPortalName -like "*$AuthorPortalName*")
        }


        if ($Response) {
            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogicModuleMetadata" )
        }
        else {
            Write-Error "No results found"
        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
