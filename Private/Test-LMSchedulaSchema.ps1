function Test-LMScheduleSchema {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [PSCustomObject]$Schedule
    )

    # Required properties
    $requiredProps = @('notify', 'type', 'recipients', 'cron', 'timezone')
    
    # Valid schedule types
    $validTypes = @('manual', 'monthly', 'weekly', 'daily', 'hourly')
    
    # Validate all required properties exist
    foreach ($prop in $requiredProps) {
        if (-not $Schedule.PSObject.Properties.Name.Contains($prop)) {
            throw "Schedule object is missing required property: $prop"
        }
    }

    # Validate property types
    if ($Schedule.notify -isnot [bool]) {
        throw "notify must be a boolean value"
    }
    
    if ($Schedule.type -isnot [string] -or $validTypes -notcontains $Schedule.type) {
        throw "type must be one of: $($validTypes -join ', ')"
    }
    
    if ($Schedule.recipients -isnot [array]) {
        throw "recipients must be an array"
    }
    
    if ($Schedule.cron -isnot [string]) {
        throw "cron must be a string"
    }
    
    if ($Schedule.timezone -isnot [string]) {
        throw "timezone must be a string"
    }

    # If recipients are provided, validate they are email addresses
    if ($Schedule.recipients.Count -gt 0) {
        $emailRegex = "^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$"
        foreach ($recipient in $Schedule.recipients) {
            if ($recipient -notmatch $emailRegex) {
                throw "Invalid email address format: $recipient"
            }
        }
    }

    # Validate cron format based on type
    switch ($Schedule.type) {
        'monthly' { if ($Schedule.cron -notmatch '^\d{2}\s\d{2}\s\*\s\d{1,2}\s\d{1,2}$') { throw "Invalid monthly cron format" } }
        'weekly'  { if ($Schedule.cron -notmatch '^\d{2}\s\d{2}\s\*\s\*\s\d{1}$') { throw "Invalid weekly cron format" } }
        'daily'   { if ($Schedule.cron -notmatch '^\d{2}\s\d{2}\s\*\s\*\s\*$') { throw "Invalid daily cron format" } }
        'hourly'  { if ($Schedule.cron -notmatch '^\d{2}\s\*\s\*\s\*\s\*$') { throw "Invalid hourly cron format" } }
        'manual'  { if ($Schedule.cron -ne '') { throw "Cron should be empty for manual type" } }
    }

    Write-Information "Supplied schedule, meets schema requirements."
}