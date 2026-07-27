function ConvertFrom-EAISdtApiTimestamp {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $Value
    )

    if ($null -eq $Value) {
        return $null
    }

    if ($Value -is [datetime]) {
        return $Value
    }

    if ($Value -is [string]) {
        if ([string]::IsNullOrWhiteSpace($Value)) {
            return $null
        }

        return [datetime]::Parse(
            $Value,
            [System.Globalization.CultureInfo]::InvariantCulture,
            [System.Globalization.DateTimeStyles]::RoundtripKind
        )
    }

    if ($Value -is [int] -or $Value -is [long] -or $Value -is [double] -or $Value -is [decimal]) {
        $numeric = [double]$Value
        if ($numeric -ge 1000000000000) {
            return [datetimeoffset]::FromUnixTimeMilliseconds([int64]$numeric).UtcDateTime
        }

        return [datetimeoffset]::FromUnixTimeSeconds([int64]$numeric).UtcDateTime
    }

    throw "Unable to convert value '$Value' to a DateTime."
}

function ConvertTo-EAISdtApiInstant {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $DateTime
    )

    $parsed = if ($DateTime -is [datetime]) {
        $DateTime
    }
    elseif ($DateTime -is [string]) {
        ConvertFrom-EAISdtApiTimestamp -Value $DateTime
    }
    elseif ($DateTime -is [int] -or $DateTime -is [long] -or $DateTime -is [double] -or $DateTime -is [decimal]) {
        ConvertFrom-EAISdtApiTimestamp -Value $DateTime
    }
    else {
        throw 'DateTime must be a DateTime, epoch value, or ISO-8601 string.'
    }

    $utc = $parsed.ToUniversalTime()
    return $utc.ToString('yyyy-MM-ddTHH:mm:ss.fffZ')
}

function Format-EAISdtInstanceId {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String]$ScheduleId,

        [Parameter(Mandatory)]
        $StartTime
    )

    $instant = ConvertTo-EAISdtApiInstant -DateTime $StartTime
    return "${ScheduleId}:${instant}"
}

function ConvertTo-EAISdtInstanceIdObject {
    [CmdletBinding()]
    param (
        $InputObject,

        [String]$ScheduleId,

        $OriginalStartTime
    )

    if (-not [string]::IsNullOrWhiteSpace($ScheduleId) -and $null -ne $OriginalStartTime) {
        return @{
            scheduleId = $ScheduleId
            startTime  = ConvertTo-EAISdtApiInstant -DateTime $OriginalStartTime
        }
    }

    if ($InputObject -is [string]) {
        $separatorIndex = $InputObject.IndexOf(':')
        if ($separatorIndex -le 0 -or $separatorIndex -ge ($InputObject.Length - 1)) {
            throw "InstanceId must be in the format 'scheduleId:isoStartTime'. Received: $InputObject"
        }

        return @{
            scheduleId = $InputObject.Substring(0, $separatorIndex)
            startTime  = ConvertTo-EAISdtApiInstant -DateTime $InputObject.Substring($separatorIndex + 1)
        }
    }

    if ($null -ne $InputObject -and $InputObject.PSObject.Properties['scheduleId'] -and $InputObject.PSObject.Properties['startTime']) {
        return @{
            scheduleId = [string]$InputObject.scheduleId
            startTime  = ConvertTo-EAISdtApiInstant -DateTime $InputObject.startTime
        }
    }

    throw 'OriginalInstanceId requires an instance object, instance ID string, or ScheduleId with OriginalStartTime.'
}

function ConvertTo-EAISdtInstanceObject {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        $InputObject
    )

    if ($null -eq $InputObject) {
        return $null
    }

    $instance = [ordered]@{}
    foreach ($property in $InputObject.PSObject.Properties) {
        $instance[$property.Name] = $property.Value
    }

    if ($instance.Contains('startTime') -and $null -ne $instance['startTime']) {
        $instance['startTime'] = ConvertFrom-EAISdtApiTimestamp -Value $instance['startTime']
    }

    if ($instance.Contains('endTime') -and $null -ne $instance['endTime']) {
        $instance['endTime'] = ConvertFrom-EAISdtApiTimestamp -Value $instance['endTime']
    }

    if ($instance.Contains('instanceId') -and $null -ne $instance['instanceId']) {
        $instanceIdObject = if ($instance['instanceId'] -is [string]) {
            ConvertTo-EAISdtInstanceIdObject -InputObject $instance['instanceId']
        }
        else {
            $normalizedInstanceId = [ordered]@{}
            foreach ($property in $instance['instanceId'].PSObject.Properties) {
                $normalizedInstanceId[$property.Name] = $property.Value
            }

            if ($normalizedInstanceId.Contains('startTime') -and $null -ne $normalizedInstanceId['startTime']) {
                $normalizedInstanceId['startTime'] = ConvertFrom-EAISdtApiTimestamp -Value $normalizedInstanceId['startTime']
            }

            $normalizedInstanceId
        }

        $instance['originalInstanceId'] = [PSCustomObject]@{
            scheduleId = [string]$instanceIdObject.scheduleId
            startTime  = ConvertFrom-EAISdtApiTimestamp -Value $instanceIdObject.startTime
        }
        $instance['instanceId'] = Format-EAISdtInstanceId -ScheduleId $instanceIdObject.scheduleId `
            -StartTime $instanceIdObject.startTime
    }

    return [PSCustomObject]$instance
}

function Resolve-EAISdtInstanceScheduleId {
    [CmdletBinding()]
    param (
        $PipelineInput,

        [String]$ScheduleId
    )

    if (-not [string]::IsNullOrWhiteSpace($ScheduleId)) {
        return $ScheduleId
    }

    if ($null -ne $PipelineInput) {
        if ($PipelineInput.PSObject.Properties['originalInstanceId'] -and $PipelineInput.originalInstanceId.PSObject.Properties['scheduleId']) {
            return [string]$PipelineInput.originalInstanceId.scheduleId
        }

        if ($PipelineInput.PSObject.Properties['instanceId']) {
            if ($PipelineInput.instanceId -is [string]) {
                return (ConvertTo-EAISdtInstanceIdObject -InputObject $PipelineInput.instanceId).scheduleId
            }

            if ($PipelineInput.instanceId.PSObject.Properties['scheduleId']) {
                return [string]$PipelineInput.instanceId.scheduleId
            }
        }

        if ($PipelineInput.PSObject.Properties['parentUid']) {
            return [string]$PipelineInput.parentUid
        }

        if ($PipelineInput.PSObject.Properties['scheduleId']) {
            return [string]$PipelineInput.scheduleId
        }
    }

    throw 'ScheduleId is required.'
}

function Resolve-EAISdtInstanceIdFromInput {
    [CmdletBinding()]
    param (
        $PipelineInput,

        [String]$InstanceId,

        [String]$ScheduleId,

        $OriginalStartTime
    )

    if (-not [string]::IsNullOrWhiteSpace($InstanceId)) {
        return ConvertTo-EAISdtInstanceIdObject -InputObject $InstanceId
    }

    if ($null -ne $PipelineInput -and $PipelineInput.PSObject.Properties['originalInstanceId']) {
        return ConvertTo-EAISdtInstanceIdObject -InputObject $PipelineInput.originalInstanceId
    }

    if ($null -ne $PipelineInput -and $PipelineInput.PSObject.Properties['instanceId']) {
        return ConvertTo-EAISdtInstanceIdObject -InputObject $PipelineInput.instanceId
    }

    return ConvertTo-EAISdtInstanceIdObject -ScheduleId $ScheduleId -OriginalStartTime $OriginalStartTime
}
