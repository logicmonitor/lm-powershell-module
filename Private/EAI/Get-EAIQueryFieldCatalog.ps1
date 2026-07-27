$Script:EAIQueryFieldCatalog = @(
    @{
        Label       = 'Event timestamp'
        Field       = 'meta.eventTimestamp'
        Type        = 'long'
        RecordTypes = @('events')
        Usages      = @('Filter', 'Order')
    }
    @{
        Label       = 'First event timestamp'
        Field       = 'meta.firstEventTimestamp'
        Type        = 'long'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order')
    }
    @{
        Label       = 'Last event timestamp'
        Field       = 'meta.lastEventTimestamp'
        Type        = 'long'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order')
    }
    @{
        Label       = 'Event count'
        Field       = 'meta.eventCount'
        Type        = 'integer'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event severity'
        Field       = 'cf.eventSeverity'
        Type        = 'integer'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Configuration item'
        Field       = 'cf.eventCI'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event name'
        Field       = 'cf.eventName'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event source'
        Field       = 'cf.eventSource'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event source ID'
        Field       = 'cf.eventSourceId'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event description'
        Field       = 'cf.eventDescription'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event object'
        Field       = 'cf.eventObject'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Event time'
        Field       = 'cf.eventTime'
        Type        = 'long'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Current severity'
        Field       = 'alertDetails.currentSeverity'
        Type        = 'integer'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Workflow state'
        Field       = 'alertDetails.workflowState'
        Type        = 'string'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Incident ID'
        Field       = 'alertDetails.incidentId'
        Type        = 'string'
        RecordTypes = @('alerts', 'insights')
        Usages      = @('Filter', 'Order', 'Return')
    }
    @{
        Label       = 'Record ID'
        Field       = '_id'
        Type        = 'string'
        RecordTypes = @('events', 'alerts', 'insights')
        Usages      = @('Order', 'Return')
    }
)

function Get-EAIQueryFieldCatalog {
    [CmdletBinding()]
    param (
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [ValidateSet('Filter', 'Order', 'Return')]
        [String]$Usage
    )

    $results = foreach ($entry in $Script:EAIQueryFieldCatalog) {
        if (-not [string]::IsNullOrWhiteSpace($RecordType) -and $entry.RecordTypes -notcontains $RecordType) {
            continue
        }

        if (-not [string]::IsNullOrWhiteSpace($Usage) -and $entry.Usages -notcontains $Usage) {
            continue
        }

        [PSCustomObject]@{
            Field       = $entry.Field
            Label       = $entry.Label
            Type        = $entry.Type
            RecordTypes = [string]($entry.RecordTypes -join ', ')
            Usages      = [string]($entry.Usages -join ', ')
        }
    }

    return @($results)
}

function Get-EAIQueryFieldCatalogEntry {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Field
    )

    foreach ($entry in $Script:EAIQueryFieldCatalog) {
        if ($entry.Field -eq $Field) {
            return $entry
        }
    }

    return $null
}

function Test-EAIQueryFieldCatalogContains {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Field
    )

    return $null -ne (Get-EAIQueryFieldCatalogEntry -Field $Field)
}

function Get-EAIQueryFieldCompleterResults {
    [CmdletBinding()]
    param (
        [String]$WordToComplete,

        [String]$RecordType,

        [ValidateSet('Filter', 'Order', 'Return')]
        [String]$Usage = 'Order'
    )

    $candidates = Get-EAIQueryFieldCatalog -RecordType $RecordType -Usage $Usage
    foreach ($candidate in $candidates) {
        if ($candidate.Field -like "$WordToComplete*") {
            [System.Management.Automation.CompletionResult]::new(
                $candidate.Field,
                $candidate.Field,
                'ParameterValue',
                "$($candidate.Label) ($($candidate.Type))"
            )
        }
    }
}

function Get-EAISdtCommonFilterFieldsFromCatalog {
    return @(
        Get-EAIQueryFieldCatalog -Usage Filter | ForEach-Object {
            @{
                Name  = "$($_.Label) ($($_.Field))"
                Field = $_.Field
                Type  = $_.Type
            }
        }
    )
}

function Get-EAIRecordsQueryErrorContext {
    [CmdletBinding()]
    param (
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        $Payload
    )

    if ($null -eq $Payload) {
        return $null
    }

    $orderClauses = @()
    if ($null -ne $Payload.order) {
        $orderClauses = @($Payload.order | ForEach-Object {
            if ($null -ne $_) {
                "$($_.field) $($_.type)"
            }
        })
    }

    return [PSCustomObject]@{
        RecordType = if ($RecordType) { $RecordType } else { $Payload.recordType }
        Order      = $orderClauses
    }
}

function Format-EAIQueryEvaluationErrorHint {
    [CmdletBinding()]
    param (
        [PSCustomObject]$ErrorContext
    )

    $lines = @(
        ''
        'The Edwin query API could not evaluate this search. Common causes include:'
        '  - An invalid or unsupported sort field in order'
        '  - An invalid filter field or filter expression'
        '  - A field/type mismatch in filter conditions (for example string vs long)'
    )

    if ($ErrorContext) {
        if ($ErrorContext.RecordType) {
            $lines += "  Record type: $($ErrorContext.RecordType)"
        }

        if ($ErrorContext.Order -and @($ErrorContext.Order).Count -gt 0) {
            $orderSummary = ($ErrorContext.Order | ForEach-Object { "[$_]" }) -join ', '
            $lines += "  Order clause(s): $orderSummary"
        }
    }

    $sampleFields = (Get-EAIQueryFieldCatalog -RecordType $ErrorContext.RecordType -Usage Order |
        Select-Object -First 6 -ExpandProperty Field) -join ', '

    $lines += @(
        ''
        'Query field names often differ from properties on returned records.'
        "Run Get-EAIQueryField -RecordType $($ErrorContext.RecordType) to list common names."
        "Examples: $sampleFields"
        'Use -Debug to inspect the full request payload sent to the API.'
    )

    return ($lines -join [Environment]::NewLine)
}
