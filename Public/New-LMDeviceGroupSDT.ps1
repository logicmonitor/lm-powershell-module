<#
.SYNOPSIS
Creates a new LogicMonitor Device Group Scheduled Downtime.

.DESCRIPTION
The New-LMDeviceGroupSDT function creates a new scheduled downtime for a LogicMonitor device group. This allows you to temporarily disable monitoring for a specific group of devices within your LogicMonitor account.

.PARAMETER Comment
Specifies the comment for the scheduled downtime. This comment will be displayed in the LogicMonitor UI.

.PARAMETER StartDate
Specifies the start date and time for the scheduled downtime. This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

.PARAMETER EndDate
Specifies the end date and time for the scheduled downtime. This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

.PARAMETER StartHour
Specifies the start hour for the scheduled downtime. This parameter is mandatory when using recurring parameter sets. The value must be between 0 and 23.

.PARAMETER StartMinute
Specifies the start minute for the scheduled downtime. This parameter is mandatory when using recurring parameter sets. The value must be between 0 and 59.

.PARAMETER EndHour
Specifies the end hour for the scheduled downtime. This parameter is mandatory when using recurring parameter sets. The value must be between 0 and 23.

.PARAMETER EndMinute
Specifies the end minute for the scheduled downtime. This parameter is mandatory when using recurring parameter sets. The value must be between 0 and 59.

.PARAMETER WeekDay
Specifies the day of the week for weekly or monthly by week SDTs. This parameter is mandatory when using the 'Weekly' or 'MonthlyByWeek' parameter sets.

.PARAMETER WeekOfMonth
Specifies which week of the month for monthly by week SDTs. This parameter is mandatory when using the 'MonthlyByWeek' parameter set.

.PARAMETER DayOfMonth
Specifies the day of the month for monthly SDTs. This parameter is mandatory when using the 'Monthly' parameter set.

.PARAMETER DeviceGroupId
Specifies the ID of the device group. This parameter is mandatory when using ID-based parameter sets.

.PARAMETER DeviceGroupName
Specifies the name of the device group. This parameter is mandatory when using name-based parameter sets.

.EXAMPLE
New-LMDeviceGroupSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -StartHour 2 -DeviceGroupName "Production Servers"
Creates a new scheduled downtime for the "Production Servers" device group.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.SDT object.
#>
Function New-LMDeviceGroupSDT {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Comment,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupName')]
        [Datetime]$StartDate,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupName')]
        [Datetime]$EndDate,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [ValidateRange(0, 23)]
        [Int]$StartHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [ValidateRange(0, 59)]
        [Int]$StartMinute,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [ValidateRange(0, 23)]
        [Int]$EndHour,

        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [ValidateRange(0, 59)]
        [Int]$EndMinute,

        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [ValidateSet("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")]
        [String]$WeekDay,

        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [ValidateSet("First", "Second", "Third", "Fourth", "Last")]
        [String]$WeekOfMonth,

        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [ValidateRange(1, 31)]
        [Int]$DayOfMonth,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupId')]
        [String]$DeviceGroupId,

        [Parameter(Mandatory, ParameterSetName = 'OneTime-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Daily-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Monthly-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'MonthlyByWeek-DeviceGroupName')]
        [Parameter(Mandatory, ParameterSetName = 'Weekly-DeviceGroupName')]
        [String]$DeviceGroupName,

        [String]$DataSourceId = "0",

        [String]$DataSourceName = "All"

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup GroupId
        If ($DeviceGroupName) {
            $LookupResult = (Get-LMDeviceGroup -Name $DeviceGroupName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DeviceGroupName) {
                Return
            }
            $DeviceGroupId = $LookupResult
        }

        Switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "OneTime-Device*" { $Occurance = "oneTime" }
            "Daily-Device*" { $Occurance = "daily" }
            "Monthly-Device*" { $Occurance = "monthly" }
            "MonthlyByWeek-Device*" { $Occurance = "monthlyByWeek" }
            "Weekly-Device*" { $Occurance = "weekly" }
        }

        #Build header and uri
        $ResourcePath = "/sdt/sdts"

        Try {
            $Data = $null

            $Data = @{
                comment       = $Comment
                deviceGroupId = $DeviceGroupId
                sdtType       = $Occurance
                #timezone        = $Timezone
                type          = "ResourceGroupSDT"
            }

            Switch ($Occurance) {
                "onetime" {
                    #Get UTC time based on selected timezone
                    # $TimeZoneID = [System.TimeZoneInfo]::FindSystemTimeZoneById($Timezone)
                    # $StartUTCTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($StartDate.ToUniversalTime(), $TimeZoneID)
                    # $EndUTCTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($EndDate.ToUniversalTime(), $TimeZoneID)

                    # $StartDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $StartUTCTime).TotalMilliseconds - $TimeZoneID.BaseUtcOffset.TotalMilliseconds
                    # $EndDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $EndUTCTime).TotalMilliseconds - $TimeZoneID.BaseUtcOffset.TotalMilliseconds

                    $StartDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $StartDate.ToUniversalTime()).TotalMilliseconds
                    $EndDateTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End $EndDate.ToUniversalTime()).TotalMilliseconds
                    $Data.Add('endDateTime', [math]::Round($EndDateTime))
                    $Data.Add('startDateTime', [math]::Round($StartDateTime))
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
            @($Data.keys) | ForEach-Object { If ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return $Response
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
