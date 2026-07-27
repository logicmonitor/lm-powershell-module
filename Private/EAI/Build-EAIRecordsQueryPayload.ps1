$Script:EAIRecordsQueryDefaultSize = 10
$Script:EAIRecordsQueryMaximumSize = 200

function Resolve-EAIRecordsQuerySize {
    [CmdletBinding()]
    param (
        $Size
    )

    if ($null -eq $Size) {
        return $Script:EAIRecordsQueryDefaultSize
    }

    if ($Size -lt 1) {
        throw "Size must be at least 1. The API default is $($Script:EAIRecordsQueryDefaultSize)."
    }

    if ($Size -gt $Script:EAIRecordsQueryMaximumSize) {
        throw "Size cannot exceed $($Script:EAIRecordsQueryMaximumSize)."
    }

    return [int]$Size
}

function Get-EAIRecordsQueryInsightTypeExpression {
    return @{
        OR = @(
            @{
                EQUALS = @(
                    @{ field = 'meta.insightType'; type = 'string' }
                    'correlation'
                )
            }
            @{
                EQUALS = @(
                    @{ field = 'meta.insightType'; type = 'string' }
                    'alertStorm'
                )
            }
            @{
                EMPTY = @(
                    @{ field = 'meta.insightType'; type = 'string' }
                )
            }
        )
    }
}

function Get-EAIRecordsQueryWithinExpression {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$TimestampField
    )

    return @{
        OR = @(
            @{
                AND = @(
                    @{
                        WITHIN = @(
                            @{ field = $TimestampField; type = 'long' }
                            @{ duration = 24; unit = 'hour' }
                        )
                    }
                )
            }
        )
    }
}

function Get-EAIRecordsQueryDefaultFilter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType
    )

    $timestampField = switch ($RecordType) {
        'events' { 'meta.eventTimestamp' }
        default  { 'meta.firstEventTimestamp' }
    }

    return [PSCustomObject]@{
        schemaName    = 'filterCondition'
        schemaVersion = 4
        expression    = @{
            AND = @(
                (Get-EAIRecordsQueryWithinExpression -TimestampField $timestampField)
                (Get-EAIRecordsQueryInsightTypeExpression)
            )
        }
    }
}

function Resolve-EAIRecordsQueryFilter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        $Filter
    )

    if ($null -eq $Filter) {
        return Get-EAIRecordsQueryDefaultFilter -RecordType $RecordType
    }

    return ConvertTo-EAIQueryFilterObject -Filter $Filter
}

function ConvertTo-EAIQueryFilterObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Filter
    )

    if ($null -eq $Filter) {
        throw 'Filter is required.'
    }

    return ConvertTo-EAISdtFilterObject -Filter $Filter
}

function Write-EAIUnknownQueryFieldWarning {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String[]]$Field,

        [Parameter(Mandatory)]
        [String]$ParameterName,

        [ValidateSet('Filter', 'Order', 'Return')]
        [String]$Usage
    )

    foreach ($fieldName in @($Field)) {
        if ([string]::IsNullOrWhiteSpace($fieldName)) {
            continue
        }

        if (-not (Test-EAIQueryFieldCatalogContains -Field $fieldName)) {
            Write-Warning "'$fieldName' is not a recognized query field for -$ParameterName. Run Get-EAIQueryField -Usage $Usage to list common field names used in Edwin queries."
        }
    }
}

function Get-EAIRecordsQueryDefaultOrderField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType
    )

    switch ($RecordType) {
        'events' { return 'meta.eventTimestamp' }
        default  { return 'meta.firstEventTimestamp' }
    }
}

function New-EAIQueryOrderClause {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Field,

        [Parameter(Mandatory)]
        [ValidateSet('asc', 'desc', 'ASC', 'DESC')]
        [String]$Type,

        [ValidateSet('MIN', 'MAX', 'SUM', 'AVG', 'MEDIAN')]
        [String]$Mode,

        [Nullable[int]]$Size
    )

    $clause = [ordered]@{
        field = $Field
        type  = $Type.ToLower()
    }

    if ($PSBoundParameters.ContainsKey('Mode')) {
        $clause.mode = $Mode
    }

    if ($PSBoundParameters.ContainsKey('Size')) {
        $clause.size = $Size
    }

    return [PSCustomObject]$clause
}

function Get-EAIQueryDefaultOrder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType
    )

    return @(
        (New-EAIQueryOrderClause -Field (Get-EAIRecordsQueryDefaultOrderField -RecordType $RecordType) -Type 'desc')
    )
}

function ConvertTo-EAIQueryOrderList {
    [CmdletBinding()]
    param (
        $Order
    )

    if ($null -eq $Order) {
        throw 'Order cannot be null when specified explicitly. Omit -Order to use the default sort.'
    }

    $normalized = foreach ($item in @($Order)) {
        if ($item -is [hashtable]) {
            if (-not $item.ContainsKey('field') -or -not $item.ContainsKey('type')) {
                throw 'Each order clause requires field and type.'
            }

            $clause = [ordered]@{
                field = [string]$item.field
                type  = [string]$item.type.ToLower()
            }

            if ($item.ContainsKey('mode')) {
                $clause.mode = [string]$item.mode
            }

            if ($item.ContainsKey('size')) {
                $clause.size = [int]$item.size
            }

            [PSCustomObject]$clause
        }
        elseif ($item -is [PSCustomObject]) {
            if ($null -eq $item.field -or $null -eq $item.type) {
                throw 'Each order clause requires field and type.'
            }

            $clause = [ordered]@{
                field = [string]$item.field
                type  = [string]$item.type.ToLower()
            }

            if ($null -ne $item.mode) {
                $clause.mode = [string]$item.mode
            }

            if ($null -ne $item.size) {
                $clause.size = [int]$item.size
            }

            [PSCustomObject]$clause
        }
        else {
            throw 'Each order entry must be a hashtable or PSCustomObject.'
        }
    }

    return @($normalized)
}

function Resolve-EAIRecordsQueryOrder {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        $Order,

        [String]$OrderField,

        [ValidateSet('asc', 'desc', 'ASC', 'DESC')]
        [String]$OrderDirection,

        [Switch]$OrderSpecified,

        [Switch]$OrderFieldSpecified,

        [Switch]$OrderDirectionSpecified
    )

    if ($OrderSpecified -and ($OrderFieldSpecified -or $OrderDirectionSpecified)) {
        throw 'Cannot specify -Order together with -OrderField or -OrderDirection.'
    }

    if ($OrderSpecified) {
        return ConvertTo-EAIQueryOrderList -Order $Order
    }

    if ($OrderFieldSpecified -or $OrderDirectionSpecified) {
        $field = if ($OrderFieldSpecified) {
            $OrderField
        }
        else {
            Get-EAIRecordsQueryDefaultOrderField -RecordType $RecordType
        }

        if ($OrderFieldSpecified) {
            Write-EAIUnknownQueryFieldWarning -Field @($field) -ParameterName 'OrderField' -Usage Order
        }

        $direction = if ($OrderDirectionSpecified) {
            $OrderDirection
        }
        else {
            'desc'
        }

        return @(New-EAIQueryOrderClause -Field $field -Type $direction)
    }

    return Get-EAIQueryDefaultOrder -RecordType $RecordType
}

function Build-EAIRecordsQueryPayload {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [String[]]$Field,

        $Filter,

        [String]$Timezone,

        $Order,

        [String]$OrderField,

        [ValidateSet('asc', 'desc', 'ASC', 'DESC')]
        [String]$OrderDirection,

        $Size,

        $ElasticQuery
    )

    $fieldsValue = $null
    if ($PSBoundParameters.ContainsKey('Field') -and $null -ne $Field -and $Field.Count -gt 0) {
        $fieldsValue = [string[]]@($Field)
        Write-EAIUnknownQueryFieldWarning -Field $fieldsValue -ParameterName 'Field' -Usage Return
    }

    $effectiveTimezone = if ([string]::IsNullOrWhiteSpace($Timezone)) {
        [TimeZoneInfo]::Local.Id
    }
    else {
        $Timezone
    }

    $orderParams = @{
        RecordType              = $RecordType
        OrderSpecified          = $PSBoundParameters.ContainsKey('Order')
        OrderFieldSpecified     = $PSBoundParameters.ContainsKey('OrderField')
        OrderDirectionSpecified = $PSBoundParameters.ContainsKey('OrderDirection')
    }

    if ($PSBoundParameters.ContainsKey('Order')) {
        $orderParams.Order = $Order
    }

    if ($PSBoundParameters.ContainsKey('OrderField')) {
        $orderParams.OrderField = $OrderField
    }

    if ($PSBoundParameters.ContainsKey('OrderDirection')) {
        $orderParams.OrderDirection = $OrderDirection
    }

    $orderList = Resolve-EAIRecordsQueryOrder @orderParams

    $payload = [ordered]@{
        env        = @{
            timezone = $effectiveTimezone
        }
        recordType = $RecordType
        fields     = $fieldsValue
        filter     = Resolve-EAIRecordsQueryFilter -RecordType $RecordType -Filter $Filter
        order      = [object[]]@($orderList)
    }

    if ($PSBoundParameters.ContainsKey('Size')) {
        $payload.size = Resolve-EAIRecordsQuerySize -Size $Size
    }

    if ($PSBoundParameters.ContainsKey('ElasticQuery')) {
        if ($null -eq $ElasticQuery) {
            throw 'ElasticQuery cannot be null when specified.'
        }

        $payload.elasticQuery = $ElasticQuery
    }

    return [PSCustomObject]$payload
}

function Format-EAIQueryRecordPath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [Parameter(Mandatory)]
        [String]$RecordId
    )

    $encodedRecordId = [System.Uri]::EscapeDataString($RecordId)
    return "/ui/query/record/$RecordType/$encodedRecordId"
}

function ConvertTo-EAIQueryRequestJson {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $InputObject
    )

    return ($InputObject | ConvertTo-Json -Depth 30)
}

function Get-EAIQueryRecordTypeName {
    [CmdletBinding()]
    param (
        [String]$RecordType,

        [Switch]$Projected
    )

    if ($Projected) {
        switch ($RecordType) {
            'events' { return 'Edwin.Event.Projected' }
            'alerts' { return 'Edwin.Alert.Projected' }
            'insights' { return 'Edwin.Insight.Projected' }
            default { return 'Edwin.Query.Record' }
        }
    }

    switch ($RecordType) {
        'events' { return 'Edwin.Event' }
        'alerts' { return 'Edwin.Alert' }
        'insights' { return 'Edwin.Insight' }
        default { return 'Edwin.Query.Record' }
    }
}

function Add-EAIQueryRecordTypeInfo {
    [CmdletBinding()]
    param (
        $InputObject,

        [String]$RecordType,

        [Switch]$Projected
    )

    if ($null -eq $InputObject) {
        return $null
    }

    $typeName = Get-EAIQueryRecordTypeName -RecordType $RecordType -Projected:$Projected
    return Add-ObjectTypeInfo -InputObject $InputObject -TypeName $typeName
}

function Test-EAIRecordsQueryUsesFieldProjection {
    [CmdletBinding()]
    param (
        [Switch]$FieldSpecified,

        $Field
    )

    return $FieldSpecified -and $null -ne $Field -and @($Field).Count -gt 0
}

function Write-EAIQueryRecordsOutput {
    [CmdletBinding()]
    param (
        $Response,

        [String]$RecordType,

        [Switch]$AsResponse,

        [Switch]$Projected
    )

    if ($AsResponse) {
        return ConvertTo-EAIQueryResponse -InputObject $Response
    }

    if ($null -eq $Response) {
        Write-Output @() -NoEnumerate
        return
    }

    $effectiveRecordType = if (-not [string]::IsNullOrWhiteSpace($RecordType)) {
        $RecordType
    }
    elseif ($null -ne $Response.meta -and $null -ne $Response.meta.recordType) {
        [string]$Response.meta.recordType
    }

    $records = if ($null -eq $Response.results) {
        @()
    }
    else {
        @($Response.results)
    }

    if ($records.Count -eq 0) {
        Write-Output @() -NoEnumerate
        return
    }

    return Add-EAIQueryRecordTypeInfo -InputObject $records -RecordType $effectiveRecordType -Projected:$Projected
}

function Write-EAIQueryRecordOutput {
    [CmdletBinding()]
    param (
        $Response,

        [Parameter(Mandatory)]
        [ValidateSet('events', 'alerts', 'insights')]
        [String]$RecordType,

        [Switch]$AsResponse,

        [Switch]$Projected
    )

    if ($AsResponse) {
        return ConvertTo-EAIQueryResponse -InputObject $Response
    }

    if ($null -eq $Response -or $null -eq $Response.results -or @($Response.results).Count -eq 0) {
        return $null
    }

    return Add-EAIQueryRecordTypeInfo -InputObject $Response.results[0] -RecordType $RecordType -Projected:$Projected
}

function ConvertTo-EAIQueryResponse {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $InputObject
    )

    if ($null -eq $InputObject) {
        return $null
    }

    return Add-ObjectTypeInfo -InputObject $InputObject -TypeName 'Edwin.Query.Response'
}
