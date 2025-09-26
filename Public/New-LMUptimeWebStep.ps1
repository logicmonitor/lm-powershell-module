<#
.SYNOPSIS
Creates a LogicMonitor Uptime web step definition.

.DESCRIPTION
New-LMUptimeWebStep generates a hashtable describing a single web step compatible with the
New-LMUptimeDevice and Set-LMUptimeDevice cmdlets. Separate parameter sets target external
(config) steps and internal (script-capable) steps while enforcing the appropriate schema
constraints.

.PARAMETER Name
Step name. Defaults to "__step0".

.PARAMETER Url
Relative or absolute URL to execute. Defaults to empty string.

.PARAMETER HttpMethod
HTTP method executed by the step. Valid values: GET, HEAD, POST. Defaults to GET.

.PARAMETER HttpVersion
HTTP protocol version. Valid values: 1, 1.1. Defaults to 1.1.

.PARAMETER Schema
HTTP schema value (http or https). Defaults to https.

.PARAMETER Enable
Indicates whether the step is enabled. Defaults to $true.

.PARAMETER UseDefaultRoot
Indicates whether the default root should be used. Defaults to $true.

.PARAMETER FollowRedirection
Indicates whether redirects are automatically followed. Defaults to $true.

.PARAMETER FullPageLoad
Indicates whether full page load is required. Defaults to $false.

.PARAMETER RequireAuth
Indicates whether authentication is required. Defaults to $false.

.PARAMETER AuthType
Authentication type when RequireAuth is true. Defaults to basic.

.PARAMETER AuthUserName
Authentication username.

.PARAMETER AuthPassword
Authentication password.

.PARAMETER AuthDomain
Authentication domain.

.PARAMETER HttpHeaders
Optional HTTP headers string.

.PARAMETER HttpBody
Optional HTTP body content.

.PARAMETER RequestType
Request type. External steps support config only; internal steps allow config or script.

.PARAMETER ResponseType
Response type. External steps support plain text/string, glob expression, JSON, XML, multi line key value pair; internal steps additionally support script.

.PARAMETER MatchType
Match type used for response evaluation. Defaults to plain.

.PARAMETER Keyword
Keyword used during response evaluation.

.PARAMETER InvertMatch
Switch to invert keyword matching behaviour.

.PARAMETER StatusCode
Expected status code string.

.PARAMETER Path
Optional path field for JSON/XPATH matching.

.PARAMETER Label
Optional step label.

.PARAMETER Description
Optional step description.

.PARAMETER TimeoutInSeconds
Optional timeout expressed in seconds.

.PARAMETER PostDataEditType
POST data edit type (Raw or Formatted Data).

.PARAMETER Type
Controls whether the step is treated as external (config) or internal (script). External set uses Type "config"; internal may use "script" or "config".

.PARAMETER ResponseScript
Response script content (internal parameter set only).

.PARAMETER RequestScript
Request script content (internal parameter set only).

.PARAMETER ParameterSetName
Internal-use parameter automatically set when emitting steps for cmdlets.

.EXAMPLE
New-LMUptimeWebStep -Type External -Name '__home' -Url '/' -Keyword 'Welcome' -StatusCode '200'

.EXAMPLE
New-LMUptimeWebStep -Type Internal -RequestType script -RequestScript $scriptBlock

.OUTPUTS
Hashtable describing an uptime web step.
#>
function New-LMUptimeWebStep {

    [CmdletBinding(DefaultParameterSetName = 'External')]
    param (
        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Name = '__step0',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Url = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [ValidateSet('GET', 'HEAD', 'POST')]
        [String]$HttpMethod = 'GET',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [ValidateSet('1', '1.1')]
        [String]$HttpVersion = '1.1',

        [Parameter(Mandatory, ParameterSetName = 'External')]
        [Parameter(Mandatory, ParameterSetName = 'Internal')]
        [ValidateSet('External', 'Internal')]
        [String]$Type,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Bool]$Enable = $true,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Bool]$UseDefaultRoot = $true,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [ValidateSet('http', 'https')]
        [String]$Schema = 'https',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Bool]$FollowRedirection = $true,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Bool]$FullPageLoad = $false,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Bool]$RequireAuth = $false,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$AuthType = 'basic',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$AuthUserName = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$AuthPassword = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$AuthDomain = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$HttpHeaders = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$HttpBody = '',

        [Parameter(ParameterSetName = 'Internal')]
        [Parameter(ParameterSetName = 'External')]
        [ValidateSet('config', 'script')]
        [String]$RequestType = 'config',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [ValidateSet('Plain text/string', 'Glob expression', 'JSON', 'XML', 'Multi-line key-value pairs')]
        [String]$ResponseType = 'Plain text/string',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$MatchType = 'plain',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Keyword = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Switch]$InvertMatch,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$StatusCode = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Path = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Label = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$Description = '',

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [Nullable[Int]]$TimeoutInSeconds,

        [Parameter(ParameterSetName = 'External')]
        [Parameter(ParameterSetName = 'Internal')]
        [String]$PostDataEditType = '',

        [Parameter(ParameterSetName = 'Internal')]
        [String]$ResponseScript = '',

        [Parameter(ParameterSetName = 'Internal')]
        [String]$RequestScript = ''
    )

    $parameterSet = $PSCmdlet.ParameterSetName

    if ($parameterSet -eq 'External') {
        if ($RequestType -eq 'script') {
            throw "RequestType 'script' is not supported for external steps."
        }
        if ($ResponseScript) {
            throw "ResponseScript is not supported for external steps."
        }
        if ($RequestScript) {
            throw "RequestScript is not supported for external steps."
        }
    }

    $step = @{
        enable            = [bool]$Enable
        useDefaultRoot    = [bool]$UseDefaultRoot
        url               = $Url
        HTTPVersion       = $HttpVersion
        HTTPMethod        = $HttpMethod
        name              = $Name
        followRedirection = [bool]$FollowRedirection
        fullpageLoad      = [bool]$FullPageLoad
        requireAuth       = [bool]$RequireAuth
        auth              = @{
            domain   = $AuthDomain
            password = $AuthPassword
            type     = $AuthType
            userName = $AuthUserName
        }
        HTTPHeaders       = $HttpHeaders
        HTTPBody          = $HttpBody
        reqType           = $RequestType
        respType          = $ResponseType
        matchType         = $MatchType
        keyword           = $Keyword
        invertMatch       = [bool]$InvertMatch.IsPresent
        statusCode        = $StatusCode
        path              = $Path
    }

    if ($Schema) { $step.schema = $Schema }
    if ($Label) { $step.label = $Label }
    if ($Description) { $step.description = $Description }
    if ($TimeoutInSeconds) { $step.timeout = [int]$TimeoutInSeconds }
    if ($PostDataEditType) { $step.postDataEditType = $PostDataEditType }

    if ($parameterSet -eq 'Internal' -and $RequestType -eq 'script') {
        $step.reqScript = if ($null -ne $RequestScript) { $RequestScript } else { '' }
        $step.respScript = if ($null -ne $ResponseScript) { $ResponseScript } else { '' }
    }

    foreach ($key in @($step.Keys)) {
        if ($null -eq $step[$key]) {
            $step.Remove($key)
        }
    }

    return $step
}

