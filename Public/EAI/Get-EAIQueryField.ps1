<#
.SYNOPSIS
Lists common Edwin query field names for filters, sorting, and field projection.

.DESCRIPTION
Get-EAIQueryField returns the query-path field names used by Invoke-EAIRecordsQuery,
Build-EAIQueryFilter, and related Edwin UI Query APIs. These names often differ from
properties on objects returned by the API (for example meta.eventTimestamp vs cf.eventTime).

Use this cmdlet to discover valid -OrderField, -Field, and filter field references before
building queries.

.PARAMETER RecordType
Optional record table filter: events, alerts, or insights.

.PARAMETER Usage
Optional usage filter: Filter, Order, or Return (field projection).

.EXAMPLE
Get-EAIQueryField

.EXAMPLE
Get-EAIQueryField -RecordType events -Usage Order

.EXAMPLE
Get-EAIQueryField -RecordType alerts -Usage Filter | Format-Table Field, Label, Type

.NOTES
Use Connect-EAIAccount before running Edwin query cmdlets.
The catalog lists commonly used fields; the API may support additional custom fields.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns Edwin.Query.Field objects describing each catalog entry.
#>
function Get-EAIQueryField {
    [CmdletBinding()]
    param (
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [ValidateSet('Filter', 'Order', 'Return')]
        [String]$Usage
    )

    $catalogParams = @{}
    if ($PSBoundParameters.ContainsKey('RecordType')) {
        $catalogParams.RecordType = $RecordType
    }
    if ($PSBoundParameters.ContainsKey('Usage')) {
        $catalogParams.Usage = $Usage
    }

    $fields = Get-EAIQueryFieldCatalog @catalogParams

    return Add-ObjectTypeInfo -InputObject $fields -TypeName 'Edwin.Query.Field'
}
