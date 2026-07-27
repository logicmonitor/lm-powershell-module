<#
.SYNOPSIS
Retrieves a single Edwin record by type and ID.

.DESCRIPTION
Get-EAIQueryRecord fetches one record via GET /ui/query/record/{recordType}/{recordId}.
Record IDs may contain slash characters; the cmdlet URL-encodes the path segment automatically.

.PARAMETER RecordType
Record table: events, alerts, or insights.

.PARAMETER RecordId
Record identifier (often the _id value from a records search).

.PARAMETER AsResponse
Returns the full API envelope (meta and results) instead of a single record object.

.EXAMPLE

Get-EAIQueryRecord -RecordType events -RecordId 'LNDP-RTRPRD001_event_name_1537191059903'

.EXAMPLE
$record = Invoke-EAIRecordsQuery -RecordType events -Field '_id' -Size 1 | Select-Object -First 1
Get-EAIQueryRecord -RecordType events -RecordId $record._id

.EXAMPLE
Get-EAIQueryRecord -RecordType events -RecordId 'eventId/12345abc'

.NOTES
Use Connect-EAIAccount before running this command.
Requires query_record API scope on the Edwin credentials.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
By default, returns an Edwin.Event, Edwin.Alert, or Edwin.Insight object. Use -AsResponse for the full
Edwin.Query.Response envelope.
#>
function Get-EAIQueryRecord {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [Parameter(Mandatory)]
        [String]$RecordId,

        [Switch]$AsResponse
    )

    if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
        return
    }

    if ([string]::IsNullOrWhiteSpace($RecordId)) {
        throw 'RecordId is required.'
    }

    $resourcePath = Format-EAIQueryRecordPath -RecordType $RecordType -RecordId $RecordId
    $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath $resourcePath
    $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'GET'
    $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

    Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation

    $response = Invoke-EAIRestMethod -Uri $uri -Method GET -Headers $headers -Auth $Script:EAIAuth `
        -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

    return Write-EAIQueryRecordOutput -Response $response -RecordType $RecordType -AsResponse:$AsResponse
}
