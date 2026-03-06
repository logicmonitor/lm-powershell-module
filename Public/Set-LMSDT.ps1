<#
.SYNOPSIS
Updates a Scheduled Down Time (SDT) entry in LogicMonitor.

.DESCRIPTION
The Set-LMSDT function modifies an existing SDT entry in LogicMonitor, allowing updates to both one-time and recurring schedules.

.PARAMETER Id
Specifies the ID of the SDT entry to modify.

.PARAMETER Comment
Specifies a comment for the SDT entry.

.PARAMETER StartDate
Specifies the start date and time for one-time SDT.

.PARAMETER EndDate
Specifies the end date and time for one-time SDT.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. For one-time date conversion, if omitted, the portal timezone is used.

.PARAMETER StartHour
Specifies the start hour (0-23) for recurring SDT.

.PARAMETER StartMinute
Specifies the start minute (0-59) for recurring SDT.

.PARAMETER EndHour
Specifies the end hour (0-23) for recurring SDT.

.PARAMETER EndMinute
Specifies the end minute (0-59) for recurring SDT.

.PARAMETER WeekDay
Specifies the day of the week for recurring SDT.

.PARAMETER WeekOfMonth
Specifies which week of the month for recurring SDT. Valid values: "First", "Second", "Third", "Fourth", "Last".

.PARAMETER DayOfMonth
Specifies the day of the month (1-31) for recurring SDT.

.EXAMPLE
Set-LMSDT -Id 123 -StartDate "2024-01-01 00:00" -EndDate "2024-01-02 00:00" -Comment "Extended maintenance"
Updates a one-time SDT entry with new dates and comment.

.INPUTS
None.

.OUTPUTS
Returns the response from the API containing the updated SDT configuration.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMSDT {

    [CmdletBinding(DefaultParameterSetName = "OneTime", SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Id,

        [String]$Comment,

        [Parameter(ParameterSetName = 'OneTime')]
        [Nullable[Datetime]]$StartDate,

        [Parameter(ParameterSetName = 'OneTime')]
        [Nullable[Datetime]]$EndDate,

        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateRange(0, 23)]
        [Nullable[Int]]$StartHour,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateRange(0, 59)]
        [Nullable[Int]]$StartMinute,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateRange(0, 23)]
        [Nullable[Int]]$EndHour,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateRange(0, 59)]
        [Nullable[Int]]$EndMinute,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [String]$WeekDay,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateSet("First", "Second", "Third", "Fourth", "Last")]
        [String]$WeekOfMonth,

        [Parameter(ParameterSetName = 'Recurring')]
        [ValidateRange(1, 31)]
        [Nullable[Int]]$DayOfMonth

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/sdt/sdts/$Id"

        $Message = "Id: $Id"

        $Data = @{}
        $Data.Add('comment', $Comment)
        $Data.Add('hour', $StartHour)
        $Data.Add('minute', $StartMinute)
        $Data.Add('endHour', $EndHour)
        $Data.Add('endMinute', $EndMinute)
        $Data.Add('weekDay', $WeekDay)
        $Data.Add('monthDay', $DayOfMonth)
        $Data.Add('weekOfMonth', $WeekOfMonth)
        if ($PSBoundParameters.ContainsKey('Timezone')) {
            $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
            $Data.Add('timezone', $EffectiveTimezone)
        }

        if ($StartDate) {
            if (-not $EffectiveTimezone) {
                $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
            }
            if (-not $Data.ContainsKey('timezone')) {
                $Data.Add('timezone', $EffectiveTimezone)
            }
            $Data.Add('startDateTime', (ConvertTo-LMSDTEpochMillis -DateTime $StartDate -Timezone $EffectiveTimezone))
        }
        if ($EndDate) {
            if (-not $EffectiveTimezone) {
                $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
            }
            if (-not $Data.ContainsKey('timezone')) {
                $Data.Add('timezone', $EffectiveTimezone)
            }
            $Data.Add('endDateTime', (ConvertTo-LMSDTEpochMillis -DateTime $EndDate -Timezone $EffectiveTimezone))
        }

        #Remove empty keys so we dont overwrite them
        $Data = Format-LMData `
            -Data $Data `
            -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

        if ($PSCmdlet.ShouldProcess($Message, "Set SDT")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request using new centralized method with retry logic
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return $Response

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
