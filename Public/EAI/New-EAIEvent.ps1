<#
.SYNOPSIS
Creates a CEF event object for Edwin ingestion.

.DESCRIPTION
New-EAIEvent builds a valid Edwin CEF payload from named parameters.
Use this cmdlet to shape third-party data before sending with Send-EAIEvents.

.PARAMETER EventCi
The configuration item associated with the event.

.PARAMETER EventObject
The object affected by the event.

.PARAMETER EventSource
The source system that generated the event.

.PARAMETER EventName
The event name.

.PARAMETER EventDescription
The event description.

.PARAMETER Severity
The event severity. Accepts enum names (Critical, Major, Minor, Warning, Indeterminate, Clear) or integer values 0-5.

.PARAMETER EventTime
The event timestamp. Defaults to current UTC time.

.PARAMETER EventId
The unique event identifier. Defaults to a new GUID.

.PARAMETER EventDomain
The event domain for tenant-federated environments. Defaults to an empty string.

.PARAMETER EventDetails
Optional additional event details.

.PARAMETER EventCiLink
Optional URL link for the configuration item.

.PARAMETER EventNameLink
Optional URL link for the event name.

.PARAMETER EventSourceId
Optional source system event identifier.

.PARAMETER EventSourceIdLink
Optional URL link for the source event identifier.

.PARAMETER SourceRecord
The original source payload to embed in source_record.

.PARAMETER Enrichments
Optional enrichment key/value pairs.

.EXAMPLE
New-EAIEvent -EventCi "server01" -EventObject "disk" -EventSource "VendorX" -EventName "Disk full" -EventDescription "Disk usage exceeded 90%" -Severity Major -SourceRecord @{ host = "server01" }

.EXAMPLE
$event = New-EAIEvent -EventCi "server01" -EventObject "CPU" -EventSource "Meraki" -EventName "High CPU" -EventDescription "CPU above threshold" -Severity 4
Send-EAIEvents -Events $event

.NOTES
Use Format-EAIEventTime for event_time when building payloads manually.
LogicMonitor portal authentication is not required for Edwin event ingestion.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
PSCustomObject with cef and enrichments properties.
#>
function New-EAIEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [String]$EventCi,

        [Parameter(Mandatory)]
        [String]$EventObject,

        [Parameter(Mandatory)]
        [String]$EventSource,

        [Parameter(Mandatory)]
        [String]$EventName,

        [Parameter(Mandatory)]
        [String]$EventDescription,

        [ValidateSet('Critical', 'Major', 'Minor', 'Warning', 'Indeterminate', 'Clear')]
        [String]$Severity = 'Indeterminate',

        [datetime]$EventTime,

        [String]$EventId,

        [String]$EventDomain = '',

        [String]$EventDetails,

        [String]$EventCiLink,

        [String]$EventNameLink,

        [String]$EventSourceId,

        [String]$EventSourceIdLink,

        [Parameter(Mandatory)]
        $SourceRecord,

        [Hashtable]$Enrichments
    )

    if (-not $EventTime) {
        $EventTime = Get-Date
    }

    if (-not $EventId) {
        $EventId = [guid]::NewGuid().ToString()
    }

    if (-not $Enrichments) {
        $Enrichments = @{}
    }

    $cef = [ordered]@{
        event_ci          = $EventCi
        event_object      = $EventObject
        event_source      = $EventSource
        event_name        = $EventName
        event_description = $EventDescription
        event_severity    = Get-EAISeverityValue -Value $Severity
        event_time        = Format-EAIEventTime -DateTime $EventTime
        event_id          = $EventId
        event_domain      = $EventDomain
        source_record     = $SourceRecord
        class             = 'event'
        version           = '1.1'
    }

    if ($PSBoundParameters.ContainsKey('EventDetails')) {
        $cef['event_details'] = $EventDetails
    }
    if ($PSBoundParameters.ContainsKey('EventCiLink')) {
        $cef['event_ci_link'] = $EventCiLink
    }
    if ($PSBoundParameters.ContainsKey('EventNameLink')) {
        $cef['event_name_link'] = $EventNameLink
    }
    if ($PSBoundParameters.ContainsKey('EventSourceId')) {
        $cef['event_source_id'] = $EventSourceId
    }
    if ($PSBoundParameters.ContainsKey('EventSourceIdLink')) {
        $cef['event_source_id_link'] = $EventSourceIdLink
    }

    [PSCustomObject]@{
        cef         = [pscustomobject]$cef
        enrichments = [pscustomobject]$Enrichments
    }
}
