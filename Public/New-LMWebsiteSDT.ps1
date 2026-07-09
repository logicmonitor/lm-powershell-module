<#
.SYNOPSIS
Creates a new Logic Monitor Website Scheduled Down Time (SDT).

.DESCRIPTION
The New-LMWebsiteSDT function creates a new SDT for a Logic Monitor website.

.PARAMETER Comment
Specifies the comment for the SDT. Required in the Default parameter set; optional with -ScheduleWizard (prompted when omitted).

.PARAMETER ScheduleWizard
Launches an interactive wizard to create the SDT. Prompts only for values not already supplied, so you can pass resource and comment parameters and receive schedule help only.

.PARAMETER Duration
Duration in minutes for one-time SDTs. Use alone (starts now) or with -StartDate.

.PARAMETER StartDate
Start date and time. Required for OneTimeRange; optional for OneTimeDuration.

.PARAMETER EndDate
End date and time. Required for OneTimeRange.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. If omitted, the portal timezone is used.

.PARAMETER SdtType
Recurring schedule type: Daily, Weekly, Monthly, or MonthlyByWeek.

.PARAMETER StartHour
Start hour (0-23) for recurring SDTs.

.PARAMETER StartMinute
Start minute (0-59) for recurring SDTs.

.PARAMETER EndHour
End hour (0-23) for recurring SDTs.

.PARAMETER EndMinute
End minute (0-59) for recurring SDTs.

.PARAMETER WeekDay
Day(s) of the week for Weekly or MonthlyByWeek SDTs. Accepts multiple values.

.PARAMETER WeekOfMonth
Week of the month for MonthlyByWeek SDTs: First, Second, Third, Fourth, or Last.

.PARAMETER DayOfMonth
Day of the month for Monthly SDTs (1-31), or -3 for the last day of the month.

.PARAMETER WebsiteId
ID of the website. Provide either -WebsiteId or -WebsiteName.

.PARAMETER WebsiteName
Name of the website. Provide either -WebsiteId or -WebsiteName.

.EXAMPLE
New-LMWebsiteSDT -ScheduleWizard
Launches the full interactive wizard to select a website, comment, and schedule.

.EXAMPLE
New-LMWebsiteSDT -ScheduleWizard -Comment "Maintenance" -WebsiteId 123
Launches the schedule wizard only; website and comment are pre-supplied.

.EXAMPLE
New-LMWebsiteSDT -Comment "Maintenance" -Duration 60 -WebsiteId 123
Creates a one-time SDT starting now for 60 minutes.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMWebsiteSDT {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '', Justification = 'Required for the ScheduleWizard to work')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$Comment,

        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Switch]$ScheduleWizard,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(1, [Int]::MaxValue)]
        [Int]$Duration,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Daily', 'Weekly', 'Monthly', 'MonthlyByWeek')]
        [String]$SdtType,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')]
        [String[]]$WeekDay,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [ValidateSet('First', 'Second', 'Third', 'Fourth', 'Last')]
        [String]$WeekOfMonth,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [Int]$DayOfMonth,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$WebsiteId,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'ScheduleWizard')]
        [String]$WebsiteName
    )

    process {
        if ($ScheduleWizard) {
            $EffectiveBound = Invoke-LMSDTCmdletWizard -ResourceType Website -BoundParameters $PSBoundParameters
            if (-not $EffectiveBound) {
                return
            }
        }
        else {
            if ($WebsiteId -and $WebsiteName) {
                throw 'Provide either -WebsiteId or -WebsiteName, not both.'
            }
            if (-not $WebsiteId -and -not $WebsiteName) {
                throw 'Either -WebsiteId or -WebsiteName is required.'
            }

            $EffectiveBound = @{}
            foreach ($Key in $PSBoundParameters.Keys) {
                $EffectiveBound[$Key] = $PSBoundParameters[$Key]
            }

            if ($WebsiteName) {
                $LookupResult = (Get-LMWebsite -Name $WebsiteName).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $WebsiteName) {
                    return
                }
                $EffectiveBound['WebsiteId'] = [string]$LookupResult
            }
        }

        $Comment = $EffectiveBound['Comment']
        $WebsiteId = $EffectiveBound['WebsiteId']
        $SchedulePayload = Build-LMSDTSchedulePayload -BoundParameters $EffectiveBound

        $Payload = @{
            comment   = $Comment
            websiteId = $WebsiteId
            type      = 'WebsiteSDT'
        }

        foreach ($Key in $SchedulePayload.Keys) {
            $Payload[$Key] = $SchedulePayload[$Key]
        }

        Invoke-LMCreateSDT -CallerPSCmdlet $PSCmdlet -Payload $Payload -ShouldProcessTarget "Comment: $Comment | WebsiteId: $WebsiteId" -ShouldProcessAction 'Create Website SDT'
    }
}
