<#
.SYNOPSIS
Creates a new Logic Monitor Device Scheduled Down Time (SDT).

.DESCRIPTION
The New-LMDeviceSDT function creates a new SDT for a Logic Monitor device. It allows you to specify the comment, start date, end date, timezone, and device ID or device name.

.PARAMETER Comment
Specifies the comment for the SDT.

.PARAMETER StartDate
Specifies the start date and time for the SDT. This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

.PARAMETER EndDate
Specifies the end date and time for the SDT. This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

.PARAMETER Timezone
Specifies the timezone for SDTs. Accepts IANA timezone IDs (e.g. America/New_York), Windows standard names (e.g. Eastern Standard Time), or the output of (Get-TimeZone).StandardName. If omitted, the portal timezone is used.

.PARAMETER StartHour
Specifies the start hour for recurring SDTs. This parameter is mandatory when using recurring parameter sets. Must be between 0 and 23.

.PARAMETER StartMinute
Specifies the start minute for recurring SDTs. This parameter is mandatory when using recurring parameter sets. Must be between 0 and 59.

.PARAMETER EndHour
Specifies the end hour for recurring SDTs. This parameter is mandatory when using recurring parameter sets. Must be between 0 and 23.

.PARAMETER EndMinute
Specifies the end minute for recurring SDTs. This parameter is mandatory when using recurring parameter sets. Must be between 0 and 59.

.PARAMETER WeekDay
Specifies the day of the week for weekly or monthly by week SDTs.

.PARAMETER WeekOfMonth
Specifies which week of the month for monthly by week SDTs.

.PARAMETER DayOfMonth
Specifies the day of the month for monthly SDTs.

.PARAMETER DeviceId
Specifies the ID of the device. This parameter is mandatory when using ID-based parameter sets.

.PARAMETER DeviceName
Specifies the name of the device. This parameter is mandatory when using name-based parameter sets.

.EXAMPLE
New-LMDeviceSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -DeviceId "12345"
Creates a one-time SDT for the device with ID "12345".

.EXAMPLE
New-LMDeviceSDT -Comment "Maintenance window" -StartDate (Get-Date).AddHours(1) -EndDate (Get-Date).AddHours(3) -DeviceName "server01" -Timezone "Eastern Standard Time"
Creates a one-time SDT using a Windows standard timezone name.

.EXAMPLE
New-LMDeviceSDT -Comment "Maintenance window" -StartDate (Get-Date).AddHours(1) -EndDate (Get-Date).AddHours(3) -DeviceName "server01" -Timezone (Get-TimeZone).StandardName
Creates a one-time SDT using the local machine's timezone via Get-TimeZone.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceSDT {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory)]
        [String]$Comment,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Datetime]$StartDate,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Datetime]$EndDate,

        [ValidateScript({ Test-LMTimezoneId -Timezone $_ })]
        [String]$Timezone,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [String]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [String]$DeviceName,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [String]$WeekDay,

        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceName')]
        [ValidateSet("First", "Second", "Third", "Fourth", "Last")]
        [String]$WeekOfMonth,

        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceName')]
        [ValidateRange(1, 31)]
        [Int]$DayOfMonth

    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Lookup DeviceId
        if ($DeviceName) {
            $LookupResult = (Get-LMDevice -Name $DeviceName).Id
            if (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                return
            }
            $DeviceId = $LookupResult
        }

        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "OneTime-Device*" { $Occurance = "oneTime" }
            "Daily-Device*" { $Occurance = "daily" }
            "Monthly-Device*" { $Occurance = "monthly" }
            "MonthlyByWeek-Device*" { $Occurance = "monthlyByWeek" }
            "Weekly-Device*" { $Occurance = "weekly" }
        }

        #Build header and uri
        $ResourcePath = "/sdt/sdts"

        $Data = $null

        $Data = @{
            comment  = $Comment
            deviceId = $DeviceId
            sdtType  = $Occurance
            type     = "ResourceSDT"
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

        $Message = "Comment: $Comment | DeviceId: $DeviceId"

        if ($PSCmdlet.ShouldProcess($Message, "Create Device SDT")) {
            
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
