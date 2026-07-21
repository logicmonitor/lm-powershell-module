$Script:EAISdtFilterSchemaName = 'filterCondition'
$Script:EAISdtFilterSchemaVersion = '4'

$Script:EAISdtUnaryFilterOperators = @('IS_EMPTY', 'NOT_EMPTY')

$Script:EAISdtFilterOperatorLabels = @{
    EQUALS               = 'Equals'
    NOT_EQUALS           = 'Not equals'
    CONTAINS             = 'Contains'
    NOT_CONTAINS         = 'Not contains'
    IN                   = 'In'
    NOT_IN               = 'Not in'
    GREATER_THAN         = 'Greater than'
    GREATER_THAN_EQUAL   = 'Greater than equal'
    LESS_THAN            = 'Less than'
    LESS_THAN_EQUAL      = 'Less than equal'
    OLDER_THAN           = 'Older than'
    WITHIN               = 'Within'
    IS_EMPTY             = 'Is Empty'
    NOT_EMPTY            = 'Not empty'
}

$Script:EAISdtFilterOperatorsByFieldType = @{
    string  = @('EQUALS', 'NOT_EQUALS', 'CONTAINS', 'NOT_CONTAINS', 'IN', 'NOT_IN', 'IS_EMPTY', 'NOT_EMPTY')
    integer = @('EQUALS', 'NOT_EQUALS', 'GREATER_THAN', 'GREATER_THAN_EQUAL', 'LESS_THAN', 'LESS_THAN_EQUAL', 'IN', 'NOT_IN', 'IS_EMPTY', 'NOT_EMPTY')
    long    = @('GREATER_THAN', 'LESS_THAN', 'OLDER_THAN', 'WITHIN', 'IS_EMPTY', 'NOT_EMPTY')
}

$Script:EAISdtCommonFilterFields = @(
    @{ Name = 'Event severity (cf.eventSeverity)'; Field = 'cf.eventSeverity'; Type = 'integer' }
    @{ Name = 'Configuration item (cf.eventCI)'; Field = 'cf.eventCI'; Type = 'string' }
    @{ Name = 'Event name (cf.eventName)'; Field = 'cf.eventName'; Type = 'string' }
    @{ Name = 'Event source (cf.eventSource)'; Field = 'cf.eventSource'; Type = 'string' }
    @{ Name = 'Event object (cf.eventObject)'; Field = 'cf.eventObject'; Type = 'string' }
    @{ Name = 'Event description (cf.eventDescription)'; Field = 'cf.eventDescription'; Type = 'string' }
    @{ Name = 'Event time (cf.eventTime)'; Field = 'cf.eventTime'; Type = 'long' }
)

function New-EAISdtFilterFieldReference {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Field,

        [Parameter(Mandatory)]
        [ValidateSet('string', 'integer', 'long')]
        [String]$Type
    )

    return @{
        field = $Field
        type  = $Type
    }
}

function New-EAISdtFilterObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Expression
    )

    return [PSCustomObject]@{
        schemaName    = $Script:EAISdtFilterSchemaName
        schemaVersion = $Script:EAISdtFilterSchemaVersion
        expression    = $Expression
    }
}

function New-EAISdtFilterCondition {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet(
            'EQUALS', 'NOT_EQUALS', 'GREATER_THAN', 'GREATER_THAN_EQUAL', 'LESS_THAN', 'LESS_THAN_EQUAL',
            'IN', 'NOT_IN', 'CONTAINS', 'NOT_CONTAINS', 'WITHIN', 'OLDER_THAN', 'IS_EMPTY', 'NOT_EMPTY'
        )]
        [String]$Operator,

        [Parameter(Mandatory)]
        [hashtable]$FieldReference,

        $Value
    )

    if ($Operator -in $Script:EAISdtUnaryFilterOperators) {
        return @{
            $Operator = @($FieldReference)
        }
    }

    if ($null -eq $Value) {
        throw "Operator '$Operator' requires a value."
    }

    return @{
        $Operator = @(
            $FieldReference
            ,$Value
        )
    }
}

function Test-EAISdtUnaryFilterOperator {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Operator
    )

    return $Operator -in $Script:EAISdtUnaryFilterOperators
}

function ConvertTo-EAISdtFilterEpochMillis {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Datetime]$DateTime
    )

    $unspecified = [Datetime]::SpecifyKind($DateTime, [System.DateTimeKind]::Unspecified)
    return [Int64]([DateTimeOffset]::new($unspecified, (Get-TimeZone).BaseUtcOffset)).ToUnixTimeMilliseconds()
}

function Read-EAISdtFilterFieldSelection {
    [CmdletBinding()]
    param ()

    $choices = @(
        $Script:EAISdtCommonFilterFields | ForEach-Object {
            @{
                Name  = $_.Name
                Value = $_
            }
        }
    ) + @(
        @{ Name = 'Custom field...'; Value = 'Custom' }
    )

    $selected = Get-LMUserSelection -Prompt 'Select the event field to match:' -Choices $choices -ChoiceLabelProperty 'Name'

    if ($selected.Value -eq 'Custom') {
        $fieldName = Read-LMWizardHost 'Enter field name (e.g. cf.eventCI or meta.alertKey)'
        if ([string]::IsNullOrWhiteSpace($fieldName)) {
            throw 'Field name is required.'
        }

        $typeChoices = @(
            @{ Name = 'String'; Value = 'string' }
            @{ Name = 'Integer'; Value = 'integer' }
            @{ Name = 'Long (timestamp)'; Value = 'long' }
        )
        $typeChoice = Get-LMUserSelection -Prompt 'Select field type:' -Choices $typeChoices -ChoiceLabelProperty 'Name'
        return New-EAISdtFilterFieldReference -Field $fieldName -Type $typeChoice.Value
    }

    return New-EAISdtFilterFieldReference -Field $selected.Value.Field -Type $selected.Value.Type
}

function Read-EAISdtFilterOperatorSelection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('string', 'integer', 'long')]
        [String]$FieldType
    )

    $operators = $Script:EAISdtFilterOperatorsByFieldType[$FieldType] | ForEach-Object {
        @{
            Name  = $Script:EAISdtFilterOperatorLabels[$_]
            Value = $_
        }
    }

    $selected = Get-LMUserSelection -Prompt 'Select comparison operator:' -Choices $operators -ChoiceLabelProperty 'Name'
    return $selected.Value
}

function Read-EAISdtFilterRelativeDurationValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Prompt
    )

    $unitChoices = @(
        @{ Name = 'Minutes'; Value = 'minute' }
        @{ Name = 'Hours'; Value = 'hour' }
        @{ Name = 'Days'; Value = 'day' }
        @{ Name = 'Weeks'; Value = 'week' }
        @{ Name = 'Months'; Value = 'month' }
    )
    $unitChoice = Get-LMUserSelection -Prompt 'Select time unit:' -Choices $unitChoices -ChoiceLabelProperty 'Name'
    $duration = Read-LMIntInRange -Prompt $Prompt -Minimum 1 -Maximum 10000
    return @{
        unit     = $unitChoice.Value
        duration = $duration
    }
}

function Read-EAISdtFilterListValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$Prompt,

        [Parameter(Mandatory)]
        [ValidateSet('string', 'integer')]
        [String]$FieldType
    )

    $rawValue = Read-LMWizardHost $Prompt
    $parts = @($rawValue -split ',' | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
    if ($parts.Count -eq 0) {
        throw 'At least one value is required.'
    }

    if ($FieldType -eq 'integer') {
        return @($parts | ForEach-Object { [int]$_ })
    }

    return @($parts)
}

function Read-EAISdtFilterValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet(
            'EQUALS', 'NOT_EQUALS', 'GREATER_THAN', 'GREATER_THAN_EQUAL', 'LESS_THAN', 'LESS_THAN_EQUAL',
            'IN', 'NOT_IN', 'CONTAINS', 'NOT_CONTAINS', 'WITHIN', 'OLDER_THAN', 'IS_EMPTY', 'NOT_EMPTY'
        )]
        [String]$Operator,

        [Parameter(Mandatory)]
        [ValidateSet('string', 'integer', 'long')]
        [String]$FieldType
    )

    switch ($Operator) {
        { $_ -in @('IS_EMPTY', 'NOT_EMPTY') } {
            return $null
        }
        { $_ -in @('WITHIN', 'OLDER_THAN') } {
            return Read-EAISdtFilterRelativeDurationValue -Prompt 'Duration'
        }
        { $_ -in @('IN', 'NOT_IN') } {
            if ($FieldType -eq 'long') {
                throw "Operator '$Operator' is not supported for long fields."
            }

            return Read-EAISdtFilterListValue -Prompt 'Enter values separated by commas' -FieldType $FieldType
        }
        { $_ -in @('CONTAINS', 'NOT_CONTAINS') } {
            return Read-EAISdtFilterListValue -Prompt 'Enter substrings separated by commas' -FieldType 'string'
        }
        { $_ -in @('GREATER_THAN', 'GREATER_THAN_EQUAL', 'LESS_THAN', 'LESS_THAN_EQUAL') } {
            if ($FieldType -eq 'long') {
                $dateTime = Read-LMDateTimeValue -Prompt 'Date/time' -Default (Get-Date)
                return ConvertTo-EAISdtFilterEpochMillis -DateTime $dateTime
            }

            return [int](Read-LMWizardHost 'Enter value')
        }
        { $_ -in @('EQUALS', 'NOT_EQUALS') } {
            $rawValue = Read-LMWizardHost 'Enter value'
            if ($FieldType -eq 'integer') {
                return [int]$rawValue
            }

            return [string]$rawValue
        }
    }

    throw "Unsupported operator '$Operator'."
}

function Test-EAISdtFilterConditionExpression {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Expression
    )

    if ($null -eq $Expression) {
        return $false
    }

    if ($Expression -is [hashtable] -or $Expression -is [PSCustomObject]) {
        $keys = if ($Expression -is [hashtable]) {
            @($Expression.Keys)
        }
        else {
            @($Expression.PSObject.Properties.Name)
        }

        if ($keys.Count -eq 1 -and $keys[0] -in @('AND', 'OR')) {
            return $true
        }

        foreach ($operator in $Script:EAISdtFilterOperatorsByFieldType.Values | ForEach-Object { $_ } | Select-Object -Unique) {
            if ($keys -contains $operator) {
                return $true
            }
        }
    }

    return $false
}

function Read-EAISdtFilterCondition {
    [CmdletBinding()]
    param ()

    $fieldReference = Read-EAISdtFilterFieldSelection
    $operator = Read-EAISdtFilterOperatorSelection -FieldType $fieldReference.type

    if (Test-EAISdtUnaryFilterOperator -Operator $operator) {
        return New-EAISdtFilterCondition -Operator $operator -FieldReference $fieldReference
    }

    $value = Read-EAISdtFilterValue -Operator $operator -FieldType $fieldReference.type
    return New-EAISdtFilterCondition -Operator $operator -FieldReference $fieldReference -Value $value
}

function Read-EAISdtFilterOrGroup {
    [CmdletBinding()]
    param ()

    $conditions = [System.Collections.Generic.List[object]]::new()
    do {
        $conditions.Add((Read-EAISdtFilterCondition))
    } while (Get-LMUserConfirmation -Prompt 'Add another condition to this OR group?' -DefaultAnswer 'n')

    if ($conditions.Count -eq 1) {
        return $conditions[0]
    }

    return @{ OR = @($conditions) }
}

function Read-EAISdtFilterExpressionInteractive {
    [CmdletBinding()]
    param ()

    $combinatorChoices = @(
        @{ Name = 'Match ALL conditions (AND)'; Value = 'AND' }
        @{ Name = 'Match ANY condition (OR)'; Value = 'OR' }
    )
    $combinator = Get-LMUserSelection -Prompt 'How should conditions be combined?' -Choices $combinatorChoices -ChoiceLabelProperty 'Name'

    $conditions = [System.Collections.Generic.List[object]]::new()

    do {
        $entryChoices = @(
            @{ Name = 'Add a condition'; Value = 'Condition' }
            @{ Name = 'Add an OR subgroup (any of...)'; Value = 'OrGroup' }
        )
        $entryChoice = Get-LMUserSelection -Prompt 'What would you like to add?' -Choices $entryChoices -ChoiceLabelProperty 'Name'

        if ($entryChoice.Value -eq 'OrGroup') {
            $conditions.Add((Read-EAISdtFilterOrGroup))
        }
        else {
            $conditions.Add((Read-EAISdtFilterCondition))
        }
    } while (Get-LMUserConfirmation -Prompt 'Add another filter rule?' -DefaultAnswer 'y')

    if ($conditions.Count -eq 0) {
        return @{ $combinator.Value = @() }
    }

    if ($conditions.Count -eq 1 -and $combinator.Value -eq 'AND') {
        $single = $conditions[0]
        if ($single.ContainsKey('OR') -or (Test-EAISdtFilterConditionExpression -Expression $single)) {
            return $single
        }
    }

    return @{ $combinator.Value = @($conditions) }
}

function Write-EAISdtFilterPreview {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        $Filter
    )

    $preview = $Filter | ConvertTo-Json -Depth 20
    Write-Host $preview
}
