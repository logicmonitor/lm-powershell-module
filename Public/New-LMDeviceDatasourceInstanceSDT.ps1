<#
.SYNOPSIS
Creates a new SDT entry for a Logic Monitor device datasource instance.

.DESCRIPTION
The New-LMDeviceDatasourceInstanceSDT function creates a new SDT entry for an instance of a Logic Monitor device datasource. It allows you to specify various parameters such as comment, start date, end date, timezone, start hour, and start minute.

.PARAMETER Comment
Specifies the comment for the new instance SDT.

.PARAMETER StartDate
Specifies the start date for the new instance SDT. This parameter is mandatory when using the 'OneTime' parameter set.

.PARAMETER EndDate
Specifies the end date for the new instance SDT. This parameter is mandatory when using the 'OneTime' parameter set.

.PARAMETER Timezone
Specifies the IANA timezone for SDTs. If omitted, the portal timezone is used.

.PARAMETER StartHour
Specifies the start hour for the new instance SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. The value must be between 0 and 23.

.PARAMETER StartMinute
Specifies the start minute for the new instance SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. The value must be between 0 and 59.

.PARAMETER EndHour
Specifies the end hour for the new instance SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. The value must be between 0 and 23.

.PARAMETER EndMinute
Specifies the end minute for the new instance SDT. This parameter is mandatory when using the 'Daily', 'Monthly', 'MonthlyByWeek', or 'Weekly' parameter sets. The value must be between 0 and 59.

.PARAMETER WeekDay
Specifies the day of the week for the new instance SDT. This parameter is mandatory when using the 'Weekly' or 'MonthlyByWeek' parameter sets.

.PARAMETER WeekOfMonth
Specifies the week of the month for the new instance SDT. This parameter is mandatory when using the 'MonthlyByWeek' parameter set.

.PARAMETER DayOfMonth
Specifies the day of the month for the new instance SDT. This parameter is mandatory when using the 'Monthly' parameter set.

.PARAMETER DeviceDataSourceInstanceId
Specifies the ID of the device datasource instance for which to create the SDT.

.EXAMPLE
New-LMDeviceDatasourceInstanceSDT -Comment "Test SDT Instance" -StartDate (Get-Date) -EndDate (Get-Date).AddDays(7) -StartHour 8 -StartMinute 30 -DeviceDataSourceInstanceId 1234
Creates a new one-time instance SDT with a comment, start date, end date, start hour, and start minute.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
function New-LMDeviceDatasourceInstanceSDT {

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
        [String]$DeviceDataSourceInstanceId

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
            comment              = $Comment
            dataSourceInstanceId = $DeviceDataSourceInstanceId
            sdtType              = $Occurance
            type                 = "DeviceDataSourceInstanceSDT"
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

        $Message = "Comment: $Comment | DeviceDataSourceInstanceId: $DeviceDataSourceInstanceId"

        if ($PSCmdlet.ShouldProcess($Message, "Create Device Datasource Instance SDT")) {
            

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
