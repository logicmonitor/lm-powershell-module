<#
.SYNOPSIS
Searches Edwin records using the UI Query API.

.DESCRIPTION
Invoke-EAIRecordsQuery posts a filter-based search to POST /ui/query/records and returns matching
records for events, alerts, or insights.

Use -RequestBody to pass a complete JSON request when cmdlet parameters are insufficient.

Run Get-EAIQueryField to list common query field names for -Field, -OrderField, and filters.
Query field paths (for example meta.eventTimestamp) often differ from properties on returned records.

.PARAMETER RecordType
Record table to query: events, alerts, or insights.

.PARAMETER Field
Optional field names to return (for example _id, cf.eventName). When omitted, fields is sent as
null and the API returns all available source fields (same as the Edwin UI).

.PARAMETER Filter
Optional filterCondition object from Build-EAIQueryFilter or a manual expression.
When omitted, the Edwin UI default filter for the record type is used (last 24 hours and
standard insightType handling).

.PARAMETER Timezone
IANA timezone for relative time filters. Defaults to the local system timezone.

.PARAMETER Order
Optional advanced sort clauses as hashtables or objects with field and type (asc or desc).
Cannot be combined with -OrderField or -OrderDirection.

.PARAMETER OrderField
Field to sort by (for example meta.eventTimestamp). Defaults to the record-type timestamp field
when -OrderDirection is specified alone.

.PARAMETER OrderDirection
Sort direction: asc or desc. Defaults to desc when -OrderField is specified alone.
When neither order parameters are specified, results sort by the record-type timestamp field descending.

.PARAMETER Size
Maximum records to return (1-200). Omit to use the API default of 10.

.PARAMETER ElasticQuery
Optional raw OpenSearch query object (advanced).

.PARAMETER RequestBody
Complete request object or JSON string. When specified, other body parameters are ignored.

.EXAMPLE
Invoke-EAIRecordsQuery -RecordType events

.EXAMPLE
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName','cf.eventSeverity'

.EXAMPLE
$filter = Build-EAIQueryFilter -PassThru
Invoke-EAIRecordsQuery -RecordType events -Field '_id','cf.eventName','cf.eventSeverity' -Filter $filter

.EXAMPLE
Invoke-EAIRecordsQuery -RecordType events `
    -Field '_id','cf.eventName' `
    -Filter (New-EAISdtFilterObject -Expression @{
        WITHIN = @(
            (New-EAISdtFilterFieldReference -Field 'cf.eventTime' -Type 'long')
            @{ unit = 'hour'; duration = 24 }
        )
    }) `
    -Size 25

.EXAMPLE
Invoke-EAIRecordsQuery -RecordType events -OrderField 'cf.eventName' -OrderDirection asc

.PARAMETER AsResponse
Returns the full API envelope (meta and results) instead of unwrapped record objects.

.EXAMPLE
Invoke-EAIRecordsQuery -RequestBody (Get-Content ./query.json -Raw)

.EXAMPLE
Get-EAIQueryField -RecordType events -Usage Order

.EXAMPLE
Invoke-EAIRecordsQuery -RecordType events -AsResponse

.NOTES
Use Connect-EAIAccount before running this command.
Requires query_records API scope on the Edwin credentials.

.INPUTS
You can pipe a filter object to override the UI default when -RecordType is specified.

.OUTPUTS
By default, returns Edwin.Event, Edwin.Alert, or Edwin.Insight record objects. Use -AsResponse for the
full Edwin.Query.Response envelope.
#>
function Invoke-EAIRecordsQuery {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'Parameterized', ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Parameterized')]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [Parameter(ParameterSetName = 'Parameterized')]
        [Alias('Fields')]
        [ArgumentCompleter({
                param ($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
                Get-EAIQueryFieldCompleterResults -WordToComplete $WordToComplete -RecordType $FakeBoundParameters['RecordType'] -Usage Return
            })]
        [String[]]$Field,

        [Parameter(ParameterSetName = 'Parameterized', ValueFromPipeline)]
        $Filter,

        [Parameter(ParameterSetName = 'Parameterized')]
        [String]$Timezone,

        [Parameter(ParameterSetName = 'Parameterized')]
        $Order,

        [Parameter(ParameterSetName = 'Parameterized')]
        [ArgumentCompleter({
                param ($CommandName, $ParameterName, $WordToComplete, $CommandAst, $FakeBoundParameters)
                Get-EAIQueryFieldCompleterResults -WordToComplete $WordToComplete -RecordType $FakeBoundParameters['RecordType'] -Usage Order
            })]
        [String]$OrderField,

        [Parameter(ParameterSetName = 'Parameterized')]
        [ValidateSet('asc', 'desc', 'ASC', 'DESC')]
        [String]$OrderDirection,

        [Parameter(ParameterSetName = 'Parameterized')]
        [ValidateRange(1, 200)]
        [Nullable[int]]$Size,

        [Parameter(ParameterSetName = 'Parameterized')]
        $ElasticQuery,

        [Parameter(Mandatory, ParameterSetName = 'RequestBody')]
        $RequestBody,

        [Switch]$AsResponse
    )

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    if ($PSCmdlet.ParameterSetName -eq 'RequestBody') {
        if ($RequestBody -is [string]) {
            try {
                $bodyObject = $RequestBody | ConvertFrom-Json -ErrorAction Stop
            }
            catch {
                throw "RequestBody is not valid JSON: $($_.Exception.Message)"
            }
        }
        else {
            $bodyObject = $RequestBody
        }

        $body = ConvertTo-EAIQueryRequestJson -InputObject $bodyObject
        $target = 'Edwin records query (custom request body)'
        $queryErrorContext = Get-EAIRecordsQueryErrorContext -Payload $bodyObject
    }
    else {
        $buildParams = @{
            RecordType = $RecordType
            Filter     = $Filter
        }

        if ($PSBoundParameters.ContainsKey('Field')) {
            $buildParams.Field = $Field
        }

        if ($PSBoundParameters.ContainsKey('Timezone')) {
            $buildParams.Timezone = $Timezone
        }

        if ($PSBoundParameters.ContainsKey('Order')) {
            $buildParams.Order = $Order
        }

        if ($PSBoundParameters.ContainsKey('OrderField')) {
            $buildParams.OrderField = $OrderField
        }

        if ($PSBoundParameters.ContainsKey('OrderDirection')) {
            $buildParams.OrderDirection = $OrderDirection
        }

        if ($PSBoundParameters.ContainsKey('Size')) {
            $buildParams.Size = $Size
        }

        if ($PSBoundParameters.ContainsKey('ElasticQuery')) {
            $buildParams.ElasticQuery = $ElasticQuery
        }

        $payload = Build-EAIRecordsQueryPayload @buildParams
        $body = ConvertTo-EAIQueryRequestJson -InputObject $payload
        $target = "Edwin $RecordType records query"
        $queryErrorContext = Get-EAIRecordsQueryErrorContext -RecordType $RecordType -Payload $payload
    }

    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'POST'
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath '/ui/query/records'
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    if ($PSCmdlet.ShouldProcess($target, 'Query Edwin records')) {
        Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation -Payload $body

        $response = Invoke-EAIRestMethod -Uri $uri -Method POST -Headers $headers -Auth $Script:EAIAuth -Body $body `
            -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging -ErrorContext $queryErrorContext

        $outputRecordType = if ($PSCmdlet.ParameterSetName -eq 'Parameterized') {
            $RecordType
        }

        $projected = $false
        if ($PSCmdlet.ParameterSetName -eq 'Parameterized') {
            $projected = Test-EAIRecordsQueryUsesFieldProjection -FieldSpecified:$PSBoundParameters.ContainsKey('Field') -Field $Field
        }
        elseif ($null -ne $bodyObject -and $null -ne $bodyObject.fields -and @($bodyObject.fields).Count -gt 0) {
            $projected = $true
        }

        return Write-EAIQueryRecordsOutput -Response $response -RecordType $outputRecordType -AsResponse:$AsResponse -Projected:$projected
    }
}