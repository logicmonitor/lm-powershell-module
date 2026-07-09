function Build-LMLogPartitionActiveContract {
    <#
    .SYNOPSIS
        Builds the activeContract payload for Log Partition create/update requests.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$BoundParameters,

        [Parameter(Mandatory)]
        [hashtable]$Values,

        [string[]]$AlwaysInclude = @()
    )

    $fieldMap = @{
        Retention             = 'retention'
        Sku                   = 'sku'
        ContractIntervalHours = 'contractIntervalHours'
        UsageLimit            = 'usageLimit'
        AutoRestartOnRenewal  = 'autoRestartOnRenewal'
        StopIngestionOnLimit  = 'stopIngestionOnLimit'
    }

    $activeContract = @{}

    foreach ($alwaysIncludeKey in $AlwaysInclude) {
        if ($fieldMap.ContainsKey($alwaysIncludeKey)) {
            $apiKey = $fieldMap[$alwaysIncludeKey]
            $activeContract[$apiKey] = $Values[$alwaysIncludeKey]
        }
    }

    foreach ($parameterName in $fieldMap.Keys) {
        if ($AlwaysInclude -contains $parameterName) {
            continue
        }

        if ($BoundParameters.ContainsKey($parameterName)) {
            $activeContract[$fieldMap[$parameterName]] = $Values[$parameterName]
        }
    }

    return $activeContract
}

function Merge-LMLogPartitionActiveContract {
    <#
    .SYNOPSIS
        Merges patch values into an existing contract for PATCH requests.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $ExistingContract,

        [Parameter(Mandatory)]
        [hashtable]$Patch
    )

    $writableFields = @(
        'retention',
        'sku',
        'contractIntervalHours',
        'usageLimit',
        'autoRestartOnRenewal',
        'stopIngestionOnLimit'
    )

    $preserveFields = @(
        'fromEpoch',
        'toEpoch',
        'id'
    )

    $merged = @{}

    foreach ($field in $preserveFields) {
        if ($null -ne $ExistingContract -and $ExistingContract.PSObject.Properties.Name -contains $field) {
            $value = $ExistingContract.$field
            if ($null -ne $value) {
                $merged[$field] = $value
            }
        }
    }

    foreach ($field in $writableFields) {
        if ($Patch.ContainsKey($field)) {
            $merged[$field] = $Patch[$field]
        }
        elseif ($null -ne $ExistingContract -and $ExistingContract.PSObject.Properties.Name -contains $field) {
            $value = $ExistingContract.$field
            if ($null -ne $value -and -not ($value -is [string] -and [string]::IsNullOrEmpty($value))) {
                $merged[$field] = $value
            }
        }
    }

    return $merged
}
