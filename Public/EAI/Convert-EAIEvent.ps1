<#
.SYNOPSIS
Converts third-party objects into Edwin CEF event payloads.

.DESCRIPTION
Convert-EAIEvent maps arbitrary input objects to Edwin CEF payloads using a property map.
Map values can be source property names or scriptblocks for computed values.

.PARAMETER InputObject
The third-party object to convert.

.PARAMETER PropertyMap
Hashtable mapping CEF field names to source property names or scriptblocks.

.PARAMETER SeverityMap
Optional hashtable mapping vendor severity aliases to Edwin severity names or values.

.PARAMETER DefaultEventSource
Optional default event_source value when not mapped.

.EXAMPLE
$data | Convert-EAIEvent -PropertyMap @{
    event_ci = 'HostName'
    event_name = 'AlertTitle'
    event_description = 'Details'
    event_object = 'Component'
    event_severity = 'Severity'
    event_source = { 'VendorX' }
} | Send-EAIEvents

.NOTES
LogicMonitor portal authentication is not required for Edwin event ingestion.
Use Connect-EAIAccount before sending events when Bearer authentication is required.

.INPUTS
You can pipe third-party objects to this command.

.OUTPUTS
PSCustomObject with cef and enrichments properties.
#>
function Convert-EAIEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        $InputObject,

        [Parameter(Mandatory)]
        [Hashtable]$PropertyMap,

        [Hashtable]$SeverityMap,

        [String]$DefaultEventSource
    )

    process {
        Convert-EAIEventCore -InputObject $InputObject -PropertyMap $PropertyMap -SeverityMap $SeverityMap -DefaultEventSource $DefaultEventSource
    }
}
