<#
.SYNOPSIS
Creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor.

.DESCRIPTION
The New-LMDeviceDatasourceSDT function creates a new device datasource SDT (Scheduled Downtime) in Logic Monitor. It allows you to specify the comment, start date and time, end date and time, and the timezone for the SDT.

.PARAMETER Comment
The comment for the SDT. This parameter is mandatory.

.PARAMETER StartDate
The start date for the SDT. This parameter is mandatory when using the 'OneTime' parameter set.

.PARAMETER EndDate
The end date for the SDT. This parameter is mandatory when using the 'OneTime' parameter set.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. If omitted, the portal timezone is used.

.PARAMETER StartHour
The start hour for the SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. Must be a value between 0 and 23.

.PARAMETER StartMinute
The start minute for the SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. Must be a value between 0 and 59.

.PARAMETER EndHour
The end hour for the SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. Must be a value between 0 and 23.

.PARAMETER EndMinute
The end minute for the SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. Must be a value between 0 and 59.

.PARAMETER WeekDay
The day of the week for the SDT. This parameter is mandatory when using the 'Weekly' or 'MonthlyByWeek' parameter sets.

.PARAMETER WeekOfMonth
The week of the month for the SDT. This parameter is mandatory when using the 'MonthlyByWeek' parameter set.

.PARAMETER DayOfMonth
The day of the month for the SDT. This parameter is mandatory when using the 'Monthly' parameter set.

.PARAMETER DeviceDataSourceId
The ID of the device datasource for which to create the SDT.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00" -EndDate "2022-01-01 06:00" -StartHour 2 -StartMinute 30 -DeviceDataSourceId 123
Creates a new one-time device datasource SDT with a comment "Maintenance window" starting on January 1, 2022, at 00:00 and ending on the same day at 06:00.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Daily maintenance" -StartHour 3 -StartMinute 0 -ParameterSet Daily -DeviceDataSourceId 123
Creates a new daily device datasource SDT with a comment "Daily maintenance" starting at 03:00.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Monthly maintenance" -StartHour 8 -StartMinute 30 -ParameterSet Monthly -DeviceDataSourceId 123
Creates a new monthly device datasource SDT with a comment "Monthly maintenance" starting on the 1st day of each month at 08:30.

.EXAMPLE
New-LMDeviceDatasourceSDT -Comment "Weekly maintenance" -StartHour 10 -StartMinute 0 -ParameterSet Weekly -DeviceDataSourceId 123
Creates a new weekly device datasource SDT with a comment "Weekly maintenance" starting every Monday at 10:00.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceDatasourceSDT {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Comment,

        [Parameter(Mandatory, ParameterSetName = 'OneTime')]
        [Datetime]$StartDate,

        [Parameter(Mandatory, ParameterSetName = 'OneTime')]
        [Datetime]$EndDate,

        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

        [Parameter(Mandatory, ParameterSetName = 'Daily')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(Mandatory, ParameterSetName = 'Daily')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(Mandatory, ParameterSetName = 'Weekly')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [String]$WeekDay,

        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek')]
        [ValidateSet("First", "Second", "Third", "Fourth", "Last")]
        [String]$WeekOfMonth,

        [Parameter(Mandatory, ParameterSetName = 'Monthly')]
        [ValidateRange(1, 31)]
        [Int]$DayOfMonth,

        [Parameter(Mandatory)]
        [String]$DeviceDataSourceId

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/sdt/sdts"

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "OneTime*" { $Occurance = "oneTime" }
            "Daily*" { $Occurance = "daily" }
            "Monthly*" { $Occurance = "monthly" }
            "MonthlyByWeek*" { $Occurance = "monthlyByWeek" }
            "Weekly*" { $Occurance = "weekly" }
        }

        $Data = $null

        $Data = @{
            comment            = $Comment
            deviceDataSourceId = $deviceDataSourceId
            sdtType            = $Occurance
            type               = "DeviceDataSourceSDT"
        }
        $EffectiveTimezone = Resolve-LMSDTTimezone -Timezone $Timezone
        $Data.Add('timezone', $EffectiveTimezone)

        switch ($Occurance) {
            "onetime" {
                $Data.Add('startDateTime', (ConvertTo-LMSDTEpochMillis -DateTime $StartDate -Timezone $EffectiveTimezone))
                $Data.Add('endDateTime', (ConvertTo-LMSDTEpochMillis -DateTime $EndDate -Timezone $EffectiveTimezone))
            }

            "daily" {
                $Data.Add('hour', $StartHour)
                $Data.Add('minute', $StartMinute)
                $Data.Add('endHour', $EndHour)
                $Data.Add('endMinute', $EndMinute)
            }

            "weekly" {
                $Data.Add('hour', $StartHour)
                $Data.Add('minute', $StartMinute)
                $Data.Add('endHour', $EndHour)
                $Data.Add('endMinute', $EndMinute)
                $Data.Add('weekDay', $WeekDay)
            }

            "monthly" {
                $Data.Add('hour', $StartHour)
                $Data.Add('minute', $StartMinute)
                $Data.Add('endHour', $EndHour)
                $Data.Add('endMinute', $EndMinute)
                $Data.Add('monthDay', $DayOfMonth)
            }

            "monthlyByWeek" {
                $Data.Add('hour', $StartHour)
                $Data.Add('minute', $StartMinute)
                $Data.Add('endHour', $EndHour)
                $Data.Add('endMinute', $EndMinute)
                $Data.Add('weekDay', $WeekDay)
                $Data.Add('weekOfMonth', $WeekOfMonth)
            }

            default {}
        }

        #Remove empty keys so we dont overwrite them
        $Data = Format-LMData `
            -Data $Data `
            -UserSpecifiedKeys @()

        $Message = "Comment: $Comment | DeviceDatasourceId: $DeviceDataSourceId"

        if ($PSCmdlet.ShouldProcess($Message, "Create Device Datasource SDT")) {
            

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return $Response

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
