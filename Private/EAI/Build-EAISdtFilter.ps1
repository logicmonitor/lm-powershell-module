$Script:EAISdtFilterSchemaName = 'filterCondition'
$Script:EAISdtFilterSchemaVersion = '4'

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
        [ValidateSet('EQUALS', 'GREATER_THAN', 'LESS_THAN', 'IN', 'CONTAINS', 'WITHIN')]
        [String]$Operator,

        [Parameter(Mandatory)]
        [hashtable]$FieldReference,

        [Parameter(Mandatory)]
        $Value
    )

    return @{
        $Operator = @(
            $FieldReference
            ,$Value
        )
    }
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

    $operators = switch ($FieldType) {
        'string' {
            @(
                @{ Name = 'Equals'; Value = 'EQUALS' }
                @{ Name = 'Contains any of (comma-separated)'; Value = 'CONTAINS' }
                @{ Name = 'In list (comma-separated)'; Value = 'IN' }
            )
        }
        'integer' {
            @(
                @{ Name = 'Equals'; Value = 'EQUALS' }
                @{ Name = 'Greater than'; Value = 'GREATER_THAN' }
                @{ Name = 'Less than'; Value = 'LESS_THAN' }
                @{ Name = 'In list (comma-separated)'; Value = 'IN' }
            )
        }
        'long' {
            @(
                @{ Name = 'Greater than (date/time)'; Value = 'GREATER_THAN' }
                @{ Name = 'Less than (date/time)'; Value = 'LESS_THAN' }
                @{ Name = 'Within relative window'; Value = 'WITHIN' }
            )
        }
    }

    $selected = Get-LMUserSelection -Prompt 'Select comparison operator:' -Choices $operators -ChoiceLabelProperty 'Name'
    return $selected.Value
}

function Read-EAISdtFilterValue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('EQUALS', 'GREATER_THAN', 'LESS_THAN', 'IN', 'CONTAINS', 'WITHIN')]
        [String]$Operator,

        [Parameter(Mandatory)]
        [ValidateSet('string', 'integer', 'long')]
        [String]$FieldType
    )

    switch ($Operator) {
        'WITHIN' {
            $unitChoices = @(
                @{ Name = 'Minutes'; Value = 'minute' }
                @{ Name = 'Hours'; Value = 'hour' }
                @{ Name = 'Days'; Value = 'day' }
                @{ Name = 'Weeks'; Value = 'week' }
                @{ Name = 'Months'; Value = 'month' }
            )
            $unitChoice = Get-LMUserSelection -Prompt 'Select time unit:' -Choices $unitChoices -ChoiceLabelProperty 'Name'
            $duration = Read-LMIntInRange -Prompt 'Duration' -Minimum 1 -Maximum 10000
            return @{
                unit     = $unitChoice.Value
                duration = $duration
            }
        }
        'IN' {
            $rawValue = Read-LMWizardHost 'Enter values separated by commas'
            $parts = @($rawValue -split ',' | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
            if ($parts.Count -eq 0) {
                throw 'At least one value is required.'
            }

            if ($FieldType -eq 'integer') {
                return @($parts | ForEach-Object { [int]$_ })
            }

            return @($parts)
        }
        'CONTAINS' {
            $rawValue = Read-LMWizardHost 'Enter substrings separated by commas'
            $parts = @($rawValue -split ',' | ForEach-Object { $_.Trim() } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
            if ($parts.Count -eq 0) {
                throw 'At least one substring is required.'
            }

            return @($parts)
        }
        'GREATER_THAN' {
            if ($FieldType -eq 'long') {
                $dateTime = Read-LMDateTimeValue -Prompt 'Date/time' -Default (Get-Date)
                return ConvertTo-EAISdtFilterEpochMillis -DateTime $dateTime
            }

            return [int](Read-LMWizardHost 'Enter value')
        }
        'LESS_THAN' {
            if ($FieldType -eq 'long') {
                $dateTime = Read-LMDateTimeValue -Prompt 'Date/time' -Default (Get-Date)
                return ConvertTo-EAISdtFilterEpochMillis -DateTime $dateTime
            }

            return [int](Read-LMWizardHost 'Enter value')
        }
        'EQUALS' {
            $rawValue = Read-LMWizardHost 'Enter value'
            if ($FieldType -eq 'integer') {
                return [int]$rawValue
            }

            return [string]$rawValue
        }
    }

    throw "Unsupported operator '$Operator'."
}

function Read-EAISdtFilterCondition {
    [CmdletBinding()]
    param ()

    $fieldReference = Read-EAISdtFilterFieldSelection
    $operator = Read-EAISdtFilterOperatorSelection -FieldType $fieldReference.type
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
        if ($single.ContainsKey('OR') -or $single.Keys.Count -eq 1 -and $single.Keys[0] -in @('EQUALS', 'GREATER_THAN', 'LESS_THAN', 'IN', 'CONTAINS', 'WITHIN')) {
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
