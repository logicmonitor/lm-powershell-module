function Test-LMTimezoneId {
    [CmdletBinding()]
    param (
        [AllowNull()]
        [AllowEmptyString()]
        [String]$Timezone
    )

    if ([String]::IsNullOrWhiteSpace($Timezone)) {
        return $true
    }

    try {
        [System.TimeZoneInfo]::FindSystemTimeZoneById($Timezone) | Out-Null
        return $true
    }
    catch {
        throw "Invalid timezone '$Timezone'. Please provide a valid timezone ID (for example, America/New_York)."
    }
}

function Resolve-LMSDTTimezone {
    [CmdletBinding()]
    param (
        [AllowNull()]
        [AllowEmptyString()]
        [String]$Timezone
    )

    if (![String]::IsNullOrWhiteSpace($Timezone)) {
        Test-LMTimezoneId -Timezone $Timezone | Out-Null
        return $Timezone
    }

    if ($Script:LMAuth.PSObject.Properties.Name -contains 'PortalTimezone' -and -not [String]::IsNullOrWhiteSpace($Script:LMAuth.PortalTimezone)) {
        return $Script:LMAuth.PortalTimezone
    }

    try {
        $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
        $PortalTimezone = @(
            $PortalInfo.timezone,
            $PortalInfo.timeZone,
            $PortalInfo.portalTimezone,
            $PortalInfo.portalTimeZone
        ) | Where-Object { -not [String]::IsNullOrWhiteSpace($_) } | Select-Object -First 1

        if (-not [String]::IsNullOrWhiteSpace($PortalTimezone)) {
            if ($Script:LMAuth.PSObject.Properties.Name -contains 'PortalTimezone') {
                $Script:LMAuth.PortalTimezone = $PortalTimezone
            }
            else {
                Add-Member -InputObject $Script:LMAuth -MemberType NoteProperty -Name PortalTimezone -Value $PortalTimezone -Force
            }
            return $PortalTimezone
        }
    }
    catch {}

    throw "Unable to resolve portal timezone automatically. Please specify -Timezone explicitly (for example, America/New_York)."
}

function ConvertTo-LMSDTEpochMillis {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Datetime]$DateTime,

        [Parameter(Mandatory)]
        [String]$Timezone
    )

    try {
        $TimeZoneInfo = [System.TimeZoneInfo]::FindSystemTimeZoneById($Timezone)
    }
    catch {
        throw "Unable to resolve timezone '$Timezone'. Please provide a valid timezone ID (for example, America/New_York)."
    }

    # Treat the provided DateTime as a wall-clock time in the selected timezone.
    $UnspecifiedDateTime = [Datetime]::SpecifyKind($DateTime, [System.DateTimeKind]::Unspecified)

    if ($TimeZoneInfo.IsInvalidTime($UnspecifiedDateTime)) {
        throw "The date/time '$($DateTime.ToString("yyyy-MM-dd HH:mm:ss"))' is invalid in timezone '$Timezone' due to a DST transition. Please choose a valid local time."
    }

    $Offset = $TimeZoneInfo.GetUtcOffset($UnspecifiedDateTime)
    $DateTimeOffset = [DateTimeOffset]::new($UnspecifiedDateTime, $Offset)
    return $DateTimeOffset.ToUnixTimeMilliseconds()
}
