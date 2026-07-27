function Write-LMSDTVariationTestLog {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param (
        [string]$Message,
        [ValidateSet('Info', 'Pass', 'Fail', 'Warn', 'Header')]
        [string]$Level = 'Info'
    )

    $color = switch ($Level) {
        'Pass' { 'Green' }
        'Fail' { 'Red' }
        'Warn' { 'Yellow' }
        'Header' { 'Cyan' }
        default { 'Gray' }
    }

    Write-Host $Message -ForegroundColor $color
}

function Get-LMSDTVariationScheduleScenarios {
    $startSoon = (Get-Date).AddMinutes(15)
    $endSoon = $startSoon.AddHours(1)

    return @(
        @{
            Key    = 'OneTimeDuration'
            Params = @{
                Duration = 30
                Timezone = 'America/New_York'
            }
        },
        @{
            Key    = 'OneTimeStartDuration'
            Params = @{
                StartDate = $startSoon
                Duration  = 45
                Timezone  = 'America/New_York'
            }
        },
        @{
            Key    = 'OneTimeRange'
            Params = @{
                StartDate = $startSoon
                EndDate   = $endSoon
                Timezone  = 'America/New_York'
            }
        },
        @{
            Key    = 'Daily'
            Params = @{
                SdtType     = 'Daily'
                StartHour   = 2
                StartMinute = 0
                EndHour     = 3
                EndMinute   = 0
                Timezone    = 'America/New_York'
            }
        },
        @{
            Key    = 'Weekly'
            Params = @{
                SdtType     = 'Weekly'
                StartHour   = 13
                StartMinute = 7
                EndHour     = 14
                EndMinute   = 7
                WeekDay     = @('Monday', 'Thursday')
                Timezone    = 'America/New_York'
            }
        },
        @{
            Key    = 'MonthlyDay'
            Params = @{
                SdtType     = 'Monthly'
                StartHour   = 1
                StartMinute = 30
                EndHour     = 2
                EndMinute   = 30
                DayOfMonth  = 15
                Timezone    = 'America/New_York'
            }
        },
        @{
            Key    = 'MonthlyLastDay'
            Params = @{
                SdtType     = 'Monthly'
                StartHour   = 23
                StartMinute = 0
                EndHour     = 23
                EndMinute   = 59
                DayOfMonth  = -3
                Timezone    = 'America/New_York'
            }
        },
        @{
            Key    = 'MonthlyByWeek'
            Params = @{
                SdtType     = 'MonthlyByWeek'
                StartHour   = 4
                StartMinute = 0
                EndHour     = 5
                EndMinute   = 0
                WeekDay     = @('Tuesday')
                WeekOfMonth = 'Second'
                Timezone    = 'America/New_York'
            }
        }
    )
}

function Get-LMSDTVariationTestResources {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param ()

    Write-LMSDTVariationTestLog 'Discovering test resources (first match per type)...' -Level Header

    $resources = @{
        Device                   = $null
        Collector                = $null
        DeviceGroup              = $null
        Website                  = $null
        WebsiteGroup             = $null
        DeviceDataSource         = $null
        DeviceDataSourceInstance = $null
    }

    $resources.Device = Get-LMDevice -BatchSize 25 -ErrorAction SilentlyContinue | Select-Object -First 1
    $resources.Collector = Get-LMCollector -BatchSize 25 -ErrorAction SilentlyContinue | Select-Object -First 1
    $resources.DeviceGroup = Get-LMDeviceGroup -BatchSize 25 -ErrorAction SilentlyContinue | Select-Object -First 1
    $resources.Website = Get-LMWebsite -BatchSize 25 -ErrorAction SilentlyContinue | Select-Object -First 1
    $resources.WebsiteGroup = Get-LMWebsiteGroup -BatchSize 25 -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($resources.Device) {
        $datasourceList = @(Get-LMDeviceDataSourceList -Id $resources.Device.id -BatchSize 50 -ErrorAction SilentlyContinue)

        foreach ($datasource in ($datasourceList | Select-Object -First 25)) {
            $instanceList = @(Get-LMDeviceDatasourceInstance -Id $resources.Device.id -DatasourceId $datasource.id -BatchSize 50 -ErrorAction SilentlyContinue)
            $instance = $instanceList | Select-Object -First 1
            if ($instance) {
                $resources.DeviceDataSource = $datasource
                $resources.DeviceDataSourceInstance = $instance
                break
            }
        }

        if (-not $resources.DeviceDataSource -and $datasourceList.Count -gt 0) {
            $resources.DeviceDataSource = $datasourceList | Select-Object -First 1
        }
    }

    foreach ($key in @('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDataSource', 'DeviceDataSourceInstance')) {
        $item = $resources[$key]
        if ($item) {
            $label = switch ($key) {
                'Device' { $item.name }
                'Collector' { $item.hostname }
                'DeviceGroup' { $item.name }
                'Website' { $item.name }
                'WebsiteGroup' { $item.name }
                'DeviceDataSource' { $item.dataSourceName }
                'DeviceDataSourceInstance' { $item.displayName }
            }
            Write-LMSDTVariationTestLog "  $key`: $label (ID: $($item.id))" -Level Info
        }
        else {
            Write-LMSDTVariationTestLog "  $key`: not found - related create tests will be skipped" -Level Warn
        }
    }

    return $resources
}

function Get-LMSDTVariationResourceTargets {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Resources
    )

    $targets = [System.Collections.Generic.List[hashtable]]::new()

    if ($Resources.Device) {
        $targets.Add(@{
                Key      = 'Device'
                Cmdlet   = 'New-LMDeviceSDT'
                Resource = @{ DeviceId = [string]$Resources.Device.id }
            })
    }
    if ($Resources.Collector) {
        $targets.Add(@{
                Key      = 'Collector'
                Cmdlet   = 'New-LMCollectorSDT'
                Resource = @{ CollectorId = [string]$Resources.Collector.id }
            })
    }
    if ($Resources.DeviceGroup) {
        $targets.Add(@{
                Key      = 'DeviceGroup'
                Cmdlet   = 'New-LMDeviceGroupSDT'
                Resource = @{ DeviceGroupId = [string]$Resources.DeviceGroup.id }
            })
    }
    if ($Resources.Website) {
        $targets.Add(@{
                Key      = 'Website'
                Cmdlet   = 'New-LMWebsiteSDT'
                Resource = @{ WebsiteId = [string]$Resources.Website.id }
            })
    }
    if ($Resources.WebsiteGroup) {
        $targets.Add(@{
                Key      = 'WebsiteGroup'
                Cmdlet   = 'New-LMWebsiteGroupSDT'
                Resource = @{ WebsiteGroupId = [string]$Resources.WebsiteGroup.id }
            })
    }
    if ($Resources.DeviceDataSource) {
        $targets.Add(@{
                Key      = 'DeviceDatasource'
                Cmdlet   = 'New-LMDeviceDatasourceSDT'
                Resource = @{ DeviceDataSourceId = [string]$Resources.DeviceDataSource.id }
            })
    }
    if ($Resources.DeviceDataSourceInstance) {
        $targets.Add(@{
                Key      = 'DeviceDatasourceInstance'
                Cmdlet   = 'New-LMDeviceDatasourceInstanceSDT'
                Resource = @{ DeviceDataSourceInstanceId = [string]$Resources.DeviceDataSourceInstance.id }
            })
    }

    return @($targets)
}

function Invoke-LMSDTVariationCreateTest {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Cmdlet,

        [Parameter(Mandatory)]
        [hashtable]$ResourceParameters,

        [Parameter(Mandatory)]
        [hashtable]$ScheduleParameters,

        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$CreatedSdtIds
    )

    $comment = if ($script:LMSDTVariationTestSuffix) {
        "Logic.Monitor.SDT.Test.$Name.$($script:LMSDTVariationTestSuffix)"
    }
    else {
        "Logic.Monitor.SDT.Test.$Name"
    }
    $params = @{}
    foreach ($key in $ResourceParameters.Keys) { $params[$key] = $ResourceParameters[$key] }
    foreach ($key in $ScheduleParameters.Keys) { $params[$key] = $ScheduleParameters[$key] }
    $params['Comment'] = $comment
    $params['Confirm'] = $false

    Write-LMSDTVariationTestLog "CREATE $Name -> $Cmdlet" -Level Info

    try {
        $result = & $Cmdlet @params
        if (-not $result -or [string]::IsNullOrWhiteSpace([string]$result.Id)) {
            throw 'Cmdlet returned no SDT Id.'
        }

        $CreatedSdtIds.Add([string]$result.Id) | Out-Null
        Write-LMSDTVariationTestLog "  PASS  $($result.Id) ($($result.Type))" -Level Pass
        return [pscustomobject]@{
            Name    = $Name
            Success = $true
            Detail  = "Id=$($result.Id) Type=$($result.Type)"
            Sdt     = $result
        }
    }
    catch {
        Write-LMSDTVariationTestLog "  FAIL  $($_.Exception.Message)" -Level Fail
        return [pscustomobject]@{
            Name    = $Name
            Success = $false
            Detail  = $_.Exception.Message
            Sdt     = $null
        }
    }
}

function Invoke-LMSDTVariationUpdateTest {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param (
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [string]$Id,

        [Parameter(Mandatory)]
        [hashtable]$UpdateParameters
    )

    $params = @{ Id = $Id; Confirm = $false }
    foreach ($key in $UpdateParameters.Keys) { $params[$key] = $UpdateParameters[$key] }

    Write-LMSDTVariationTestLog "UPDATE $Name -> Set-LMSDT ($Id)" -Level Info

    try {
        $result = Set-LMSDT @params
        Write-LMSDTVariationTestLog '  PASS' -Level Pass
        return [pscustomobject]@{
            Name    = $Name
            Success = $true
            Detail  = "Updated Id=$Id"
            Sdt     = $result
        }
    }
    catch {
        Write-LMSDTVariationTestLog "  FAIL  $($_.Exception.Message)" -Level Fail
        return [pscustomobject]@{
            Name    = $Name
            Success = $false
            Detail  = $_.Exception.Message
            Sdt     = $null
        }
    }
}

function Remove-LMSDTVariationTestSdts {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for integration test output')]
    param (
        [Parameter(Mandatory)]
        [AllowEmptyCollection()]
        [System.Collections.Generic.List[string]]$CreatedSdtIds
    )

    if ($CreatedSdtIds.Count -eq 0) {
        return
    }

    Write-LMSDTVariationTestLog "Cleaning up $($CreatedSdtIds.Count) created SDT(s)..." -Level Header
    foreach ($sdtId in $CreatedSdtIds) {
        try {
            Remove-LMSDT -Id $sdtId -Confirm:$false -ErrorAction Stop
            Write-LMSDTVariationTestLog "  Removed $sdtId" -Level Info
        }
        catch {
            Write-LMSDTVariationTestLog "  Failed to remove ${sdtId}: $($_.Exception.Message)" -Level Warn
        }
    }
}
