function Build-EAISdtOverridePayload {
    [CmdletBinding(DefaultParameterSetName = 'Adjust')]
    param (
        [Parameter(Mandatory)]
        $OriginalInstanceId,

        [Parameter(ParameterSetName = 'Skip')]
        [Switch]$Skip,

        [Parameter(ParameterSetName = 'Adjust')]
        $NewStartTime,

        [Parameter(ParameterSetName = 'Adjust')]
        $NewEndTime,

        [String]$Summary
    )

    $originalId = if ($OriginalInstanceId -is [hashtable] -and $OriginalInstanceId.ContainsKey('scheduleId')) {
        $OriginalInstanceId
    }
    else {
        ConvertTo-EAISdtInstanceIdObject -InputObject $OriginalInstanceId
    }

    $payload = [ordered]@{
        originalInstanceId = @{
            scheduleId = $originalId.scheduleId
            startTime  = $originalId.startTime
        }
    }

    if ($PSCmdlet.ParameterSetName -eq 'Skip') {
        $payload.status = 'SKIPPED'
    }
    else {
        if ($null -eq $NewStartTime -or $null -eq $NewEndTime) {
            throw 'NewStartTime and NewEndTime are required when adjusting an instance.'
        }

        $start = ConvertFrom-EAISdtApiTimestamp -Value $NewStartTime
        $end = ConvertFrom-EAISdtApiTimestamp -Value $NewEndTime
        if ($start -ge $end) {
            throw 'NewStartTime must be before NewEndTime.'
        }

        $payload.status = 'SCHEDULED'
        $payload.newStartTime = ConvertTo-EAISdtApiInstant -DateTime $NewStartTime
        $payload.newEndTime = ConvertTo-EAISdtApiInstant -DateTime $NewEndTime
    }

    if ($PSBoundParameters.ContainsKey('Summary')) {
        $payload.summary = $Summary
    }

    return [PSCustomObject]$payload
}

function ConvertTo-EAISdtOverrideRequestBody {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [Object[]]$Override
    )

    if ($null -eq $Override) {
        return @()
    }

    $normalized = foreach ($item in $Override) {
        if ($item -is [hashtable] -or $item -is [PSCustomObject]) {
            $item
        }
        else {
            throw 'Each override must be a hashtable or PSCustomObject.'
        }
    }

    return @($normalized)
}
