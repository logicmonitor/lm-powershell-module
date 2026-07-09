$Script:LMSDTResourceWizardDefinitions = @{
    Device = @{
        Label           = 'device'
        IdParam         = 'DeviceId'
        NameParam       = 'DeviceName'
        GetById         = { param($Id) Get-LMDevice -Id $Id }
        GetByName       = { param($Name) Get-LMDevice -Name $Name }
        Browse          = { Get-LMDevice -BatchSize 100 }
        DisplayProperty = 'name'
        IdProperty      = 'id'
    }
    Collector = @{
        Label           = 'collector'
        IdParam         = 'CollectorId'
        NameParam       = 'CollectorName'
        GetById         = { param($Id) Get-LMCollector -Id $Id }
        GetByName       = { param($Name) Get-LMCollector -Name $Name }
        Browse          = { Get-LMCollector -BatchSize 100 }
        DisplayProperty = 'hostname'
        FilterProperty  = 'hostname'
        IdProperty      = 'id'
    }
    DeviceGroup = @{
        Label           = 'device group'
        IdParam         = 'DeviceGroupId'
        NameParam       = 'DeviceGroupName'
        GetById         = { param($Id) Get-LMDeviceGroup -Id $Id }
        GetByName       = { param($Name) Get-LMDeviceGroup -Name $Name }
        Browse          = { Get-LMDeviceGroup -BatchSize 100 }
        DisplayProperty = 'name'
        IdProperty      = 'id'
    }
    Website = @{
        Label           = 'website'
        IdParam         = 'WebsiteId'
        NameParam       = 'WebsiteName'
        GetById         = { param($Id) Get-LMWebsite -Id $Id }
        GetByName       = { param($Name) Get-LMWebsite -Name $Name }
        Browse          = { Get-LMWebsite -BatchSize 100 }
        DisplayProperty = 'name'
        IdProperty      = 'id'
    }
    WebsiteGroup = @{
        Label           = 'website group'
        IdParam         = 'WebsiteGroupId'
        NameParam       = 'WebsiteGroupName'
        GetById         = { param($Id) Get-LMWebsiteGroup -Id $Id }
        GetByName       = { param($Name) Get-LMWebsiteGroup -Name $Name }
        Browse          = { Get-LMWebsiteGroup -BatchSize 100 }
        DisplayProperty = 'name'
        IdProperty      = 'id'
    }
}

function Test-LMSDTResourceComplete {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    switch ($ResourceType) {
        'DeviceDatasource' {
            return $BoundParameters.ContainsKey('DeviceDataSourceId') -and
                -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceDataSourceId'])
        }
        'DeviceDatasourceInstance' {
            return $BoundParameters.ContainsKey('DeviceDataSourceInstanceId') -and
                -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceDataSourceInstanceId'])
        }
        default {
            $Definition = $Script:LMSDTResourceWizardDefinitions[$ResourceType]
            $HasId = $BoundParameters.ContainsKey($Definition.IdParam) -and
                -not [string]::IsNullOrWhiteSpace([string]$BoundParameters[$Definition.IdParam])
            $HasName = $BoundParameters.ContainsKey($Definition.NameParam) -and
                -not [string]::IsNullOrWhiteSpace([string]$BoundParameters[$Definition.NameParam])
            return $HasId -or $HasName
        }
    }
}

function Get-LMSDTWizardFilteredBrowseItems {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [scriptblock]$Browse,

        [Parameter(Mandatory)]
        [string]$FilterProperty,

        [string]$FilterText
    )

    $items = @(& $Browse)
    if ([string]::IsNullOrWhiteSpace($FilterText)) {
        return $items
    }

    return @($items | Where-Object {
            $value = $_.($FilterProperty)
            -not [string]::IsNullOrWhiteSpace([string]$value) -and
            [string]$value -like "*$FilterText*"
        })
}

function Invoke-LMSDTWizardBrowseSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [scriptblock]$Browse,

        [Parameter(Mandatory)]
        [string]$DisplayProperty,

        [Parameter(Mandatory)]
        [string]$IdProperty,

        [Parameter(Mandatory)]
        [string]$ResourceLabel,

        [string]$FilterProperty
    )

    if ([string]::IsNullOrWhiteSpace($FilterProperty)) {
        $FilterProperty = $DisplayProperty
    }

    do {
        $filterText = Read-LMWizardHost 'Filter by name (leave blank for first page; q to cancel)'
        $items = Get-LMSDTWizardFilteredBrowseItems -Browse $Browse -FilterProperty $FilterProperty -FilterText $filterText

        if ($items.Count -eq 0) {
            Write-Host "No matching $ResourceLabel resources found." -ForegroundColor Yellow
            continue
        }

        $selected = Select-LMResourceFromList -Items $items -DisplayProperty $DisplayProperty -IdProperty $IdProperty -ResourceLabel $ResourceLabel
        if ($selected) {
            return $selected
        }
    } while ($true)
}

function Select-LMResourceFromList {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [AllowEmptyCollection()]
        [array]$Items,

        [Parameter(Mandatory)]
        [string]$DisplayProperty,

        [Parameter(Mandatory)]
        [string]$IdProperty,

        [Parameter(Mandatory)]
        [string]$ResourceLabel
    )

    if ($null -eq $Items -or @($Items).Count -eq 0) {
        Write-Host "No $ResourceLabel resources found." -ForegroundColor Yellow
        return $null
    }

    $choices = @($Items | ForEach-Object {
            @{
                Name  = "$($_.($DisplayProperty)) (ID: $($_.($IdProperty)))"
                Value = $_
            }
        })

    $selected = Get-LMUserSelection -Prompt "Select a $($ResourceLabel):" -Choices $choices -ChoiceLabelProperty 'Name'
    return $selected.Value
}

function Write-LMSDTWizardResourceMatch {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Definition,

        [Parameter(Mandatory)]
        $Resource
    )

    $displayValue = $Resource.($Definition.DisplayProperty)
    $idValue = $Resource.($Definition.IdProperty)
    Write-Host "Selected $($Definition.Label): $displayValue (ID: $idValue)" -ForegroundColor Green
}

function Write-LMSDTWizardSelectionMatch {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [string]$Label,

        [Parameter(Mandatory)]
        [string]$DisplayValue,

        [Parameter(Mandatory)]
        [string]$Id
    )

    Write-Host "Selected $Label`: $DisplayValue (ID: $Id)" -ForegroundColor Green
}

function Get-LMSDTWizardTargetSummaryLines {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    $lines = [System.Collections.Generic.List[string]]::new()

    switch ($ResourceType) {
        'Device' {
            $deviceId = [string]$BoundParameters['DeviceId']
            $device = Get-LMDevice -Id $deviceId -ErrorAction SilentlyContinue
            if ($device) {
                $lines.Add("Device: $($device.name) (ID: $($device.id))")
            }
            else {
                $lines.Add("Device ID: $deviceId")
            }
        }
        'Collector' {
            $collectorId = [string]$BoundParameters['CollectorId']
            $collector = Get-LMCollector -Id $collectorId -ErrorAction SilentlyContinue
            if ($collector) {
                $lines.Add("Collector: $($collector.hostname) (ID: $($collector.id))")
            }
            else {
                $lines.Add("Collector ID: $collectorId")
            }
        }
        'DeviceGroup' {
            $groupId = [string]$BoundParameters['DeviceGroupId']
            $group = Get-LMDeviceGroup -Id $groupId -ErrorAction SilentlyContinue
            if ($group) {
                $lines.Add("Device group: $($group.name) (ID: $($group.id))")
            }
            else {
                $lines.Add("Device group ID: $groupId")
            }
        }
        'Website' {
            $websiteId = [string]$BoundParameters['WebsiteId']
            $website = Get-LMWebsite -Id $websiteId -ErrorAction SilentlyContinue
            if ($website) {
                $lines.Add("Website: $($website.name) (ID: $($website.id))")
            }
            else {
                $lines.Add("Website ID: $websiteId")
            }
        }
        'WebsiteGroup' {
            $groupId = [string]$BoundParameters['WebsiteGroupId']
            $group = Get-LMWebsiteGroup -Id $groupId -ErrorAction SilentlyContinue
            if ($group) {
                $lines.Add("Website group: $($group.name) (ID: $($group.id))")
            }
            else {
                $lines.Add("Website group ID: $groupId")
            }
        }
        'DeviceDatasource' {
            $deviceId = [string]$BoundParameters['DeviceId']
            $device = Get-LMDevice -Id $deviceId -ErrorAction SilentlyContinue
            if ($device) {
                $lines.Add("Device: $($device.name) (ID: $($device.id))")
            }
            else {
                $lines.Add("Device ID: $deviceId")
            }

            $datasourceId = [string]$BoundParameters['DeviceDataSourceId']
            $datasource = @(Get-LMDeviceDataSourceList -Id $deviceId -BatchSize 100 -ErrorAction SilentlyContinue) |
                Where-Object { [string]$_.id -eq $datasourceId } |
                Select-Object -First 1
            if ($datasource) {
                $lines.Add("Datasource: $($datasource.dataSourceName) (ID: $($datasource.id))")
            }
            else {
                $lines.Add("Datasource ID: $datasourceId")
            }
        }
        'DeviceDatasourceInstance' {
            $deviceId = [string]$BoundParameters['DeviceId']
            $device = Get-LMDevice -Id $deviceId -ErrorAction SilentlyContinue
            if ($device) {
                $lines.Add("Device: $($device.name) (ID: $($device.id))")
            }
            else {
                $lines.Add("Device ID: $deviceId")
            }

            $datasourceId = [string]$BoundParameters['DeviceDataSourceId']
            $datasource = @(Get-LMDeviceDataSourceList -Id $deviceId -BatchSize 100 -ErrorAction SilentlyContinue) |
                Where-Object { [string]$_.id -eq $datasourceId } |
                Select-Object -First 1
            if ($datasource) {
                $lines.Add("Datasource: $($datasource.dataSourceName) (ID: $($datasource.id))")
            }
            else {
                $lines.Add("Datasource ID: $datasourceId")
            }

            $instanceId = [string]$BoundParameters['DeviceDataSourceInstanceId']
            $instance = @(Get-LMDeviceDatasourceInstance -Id $deviceId -DatasourceId $datasourceId -BatchSize 100 -ErrorAction SilentlyContinue) |
                Where-Object { [string]$_.id -eq $instanceId } |
                Select-Object -First 1
            if ($instance) {
                $lines.Add("Datasource instance: $($instance.displayName) (ID: $($instance.id))")
            }
            else {
                $lines.Add("Datasource instance ID: $instanceId")
            }
        }
    }

    return @($lines)
}

function Get-LMSDTWizardResourceById {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Definition
    )

    do {
        $resourceId = Read-LMWizardHost "Enter $($Definition.Label) ID (q to cancel)"
        $resource = & $Definition.GetById $resourceId
        if ($resource) {
            Write-LMSDTWizardResourceMatch -Definition $Definition -Resource $resource
            return @{ $Definition.IdParam = [string]$resource.($Definition.IdProperty) }
        }

        Write-Host "No $($Definition.Label) found with ID '$resourceId'." -ForegroundColor Yellow
    } while ($true)
}

function Get-LMSDTWizardResourceByName {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Definition
    )

    do {
        $resourceName = Read-LMWizardHost "Enter $($Definition.Label) name (q to cancel)"
        $resource = & $Definition.GetByName $resourceName
        if (-not (Test-LookupResult -Result $resource -LookupString $resourceName)) {
            Write-LMSDTWizardResourceMatch -Definition $Definition -Resource $resource
            return @{ $Definition.IdParam = [string]$resource.($Definition.IdProperty) }
        }

        Write-Host "No $($Definition.Label) found with name '$resourceName'." -ForegroundColor Yellow
    } while ($true)
}

function Invoke-LMSDTWizardResourceSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [hashtable]$Definition
    )

    do {
        $methods = @(
            @{ Name = "Enter $($Definition.Label) ID"; Value = 'Id' }
            @{ Name = "Enter $($Definition.Label) name"; Value = 'Name' }
            @{ Name = "Browse $($Definition.Label)s"; Value = 'Browse' }
        )
        $method = Get-LMUserSelection -Prompt "How do you want to select the $($Definition.Label)?" -Choices $methods -ChoiceLabelProperty 'Name'

        $selection = switch ($method.Value) {
            'Id' { Get-LMSDTWizardResourceById -Definition $Definition }
            'Name' { Get-LMSDTWizardResourceByName -Definition $Definition }
            'Browse' {
                $filterProperty = if ($Definition.FilterProperty) { $Definition.FilterProperty } else { $Definition.DisplayProperty }
                $selected = Invoke-LMSDTWizardBrowseSelection `
                    -Browse $Definition.Browse `
                    -DisplayProperty $Definition.DisplayProperty `
                    -IdProperty $Definition.IdProperty `
                    -ResourceLabel $Definition.Label `
                    -FilterProperty $filterProperty
                if ($selected) {
                    Write-LMSDTWizardResourceMatch -Definition $Definition -Resource $selected
                    @{ $Definition.IdParam = [string]$selected.($Definition.IdProperty) }
                }
            }
        }

        if ($selection) {
            return $selection
        }

        if (-not (Get-LMUserConfirmation -Prompt 'Choose a different selection method?' -DefaultAnswer 'y')) {
            return $null
        }
    } while ($true)
}

function Invoke-LMSDTDeviceSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [hashtable]$BoundParameters
    )

    if ($BoundParameters.ContainsKey('DeviceId') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceId'])) {
        return @{
            DeviceId = $BoundParameters['DeviceId']
        }
    }

    if ($BoundParameters.ContainsKey('DeviceName') -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceName'])) {
        return @{
            DeviceName = $BoundParameters['DeviceName']
        }
    }

    return Invoke-LMSDTWizardResourceSelection -Definition $Script:LMSDTResourceWizardDefinitions['Device']
}

function Invoke-LMSDTSimpleResourceWizard {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup')]
        [String]$ResourceType
    )

    return Invoke-LMSDTWizardResourceSelection -Definition $Script:LMSDTResourceWizardDefinitions[$ResourceType]
}

function Invoke-LMSDTDatasourceSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [String]$DeviceId
    )

    $datasources = @(Get-LMDeviceDataSourceList -Id $DeviceId -BatchSize 25)
    if ($datasources.Count -eq 0) {
        Write-Host "No datasources found for device ID '$DeviceId'." -ForegroundColor Yellow
        return $null
    }

    $choices = @($datasources | ForEach-Object {
            @{
                Name  = "$($_.dataSourceName) (ID: $($_.id))"
                Value = $_
            }
        })

    $selected = Get-LMUserSelection -Prompt 'Select a device datasource:' -Choices $choices -ChoiceLabelProperty 'Name'
    Write-LMSDTWizardSelectionMatch -Label 'datasource' -DisplayValue $selected.Value.dataSourceName -Id $selected.Value.id
    return @{ DeviceDataSourceId = [string]$selected.Value.id }
}

function Invoke-LMSDTDatasourceInstanceSelection {
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Required for interactive wizards')]
    param (
        [Parameter(Mandatory)]
        [String]$DeviceId,

        [Parameter(Mandatory)]
        [String]$DatasourceId
    )

    $instances = @(Get-LMDeviceDatasourceInstance -Id $DeviceId -DatasourceId $DatasourceId -BatchSize 25)
    if ($instances.Count -eq 0) {
        Write-Host "No datasource instances found for device ID '$DeviceId' and datasource ID '$DatasourceId'." -ForegroundColor Yellow
        return $null
    }

    $choices = @($instances | ForEach-Object {
            @{
                Name  = "$($_.displayName) (ID: $($_.id))"
                Value = $_
            }
        })

    $selected = Get-LMUserSelection -Prompt 'Select a datasource instance:' -Choices $choices -ChoiceLabelProperty 'Name'
    Write-LMSDTWizardSelectionMatch -Label 'datasource instance' -DisplayValue $selected.Value.displayName -Id $selected.Value.id
    return @{ DeviceDataSourceInstanceId = [string]$selected.Value.id }
}

function Invoke-LMSDTResourceWizard {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    if (Test-LMSDTResourceComplete -ResourceType $ResourceType -BoundParameters $BoundParameters) {
        return @{}
    }

    switch ($ResourceType) {
        'DeviceDatasource' {
            $deviceSelection = Invoke-LMSDTDeviceSelection -BoundParameters $BoundParameters
            if ($null -eq $deviceSelection) {
                return $null
            }
            $deviceId = $deviceSelection['DeviceId']
            if (-not $deviceId -and $deviceSelection.ContainsKey('DeviceName')) {
                $device = Get-LMDevice -Name $deviceSelection['DeviceName']
                if (Test-LookupResult -Result $device -LookupString $deviceSelection['DeviceName']) {
                    Write-Host "No device found with name '$($deviceSelection['DeviceName'])'." -ForegroundColor Yellow
                    return $null
                }
                Write-LMSDTWizardResourceMatch -Definition $Script:LMSDTResourceWizardDefinitions['Device'] -Resource $device
                $deviceId = [string]$device.id
            }
            $datasourceSelection = Invoke-LMSDTDatasourceSelection -DeviceId $deviceId
            if ($null -eq $datasourceSelection) {
                return $null
            }
            return $deviceSelection + $datasourceSelection
        }
        'DeviceDatasourceInstance' {
            $deviceSelection = Invoke-LMSDTDeviceSelection -BoundParameters $BoundParameters
            if ($null -eq $deviceSelection) {
                return $null
            }
            $deviceId = $deviceSelection['DeviceId']
            if (-not $deviceId -and $deviceSelection.ContainsKey('DeviceName')) {
                $device = Get-LMDevice -Name $deviceSelection['DeviceName']
                if (Test-LookupResult -Result $device -LookupString $deviceSelection['DeviceName']) {
                    Write-Host "No device found with name '$($deviceSelection['DeviceName'])'." -ForegroundColor Yellow
                    return $null
                }
                Write-LMSDTWizardResourceMatch -Definition $Script:LMSDTResourceWizardDefinitions['Device'] -Resource $device
                $deviceId = [string]$device.id
            }

            $datasourceSelection = Invoke-LMSDTDatasourceSelection -DeviceId $deviceId
            if ($null -eq $datasourceSelection) {
                return $null
            }
            $datasourceId = $datasourceSelection['DeviceDataSourceId']
            $instanceSelection = Invoke-LMSDTDatasourceInstanceSelection -DeviceId $deviceId -DatasourceId $datasourceId
            if ($null -eq $instanceSelection) {
                return $null
            }
            return $deviceSelection + $datasourceSelection + $instanceSelection
        }
        default {
            $selection = Invoke-LMSDTSimpleResourceWizard -ResourceType $ResourceType
            if ($null -eq $selection) {
                return $null
            }
            return $selection
        }
    }
}

function Resolve-LMSDTResourceIdentifiers {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    $Result = @{}
    foreach ($Key in $BoundParameters.Keys) {
        $Result[$Key] = $BoundParameters[$Key]
    }

    switch ($ResourceType) {
        'DeviceDatasource' {
            if ($Result.ContainsKey('DeviceName') -and -not $Result.ContainsKey('DeviceId')) {
                $lookup = (Get-LMDevice -Name $Result['DeviceName']).Id
                if (Test-LookupResult -Result $lookup -LookupString $Result['DeviceName']) {
                    throw "Unable to resolve device name '$($Result['DeviceName'])'."
                }
                $Result['DeviceId'] = [string]$lookup
            }
        }
        'DeviceDatasourceInstance' {
            if ($Result.ContainsKey('DeviceName') -and -not $Result.ContainsKey('DeviceId')) {
                $lookup = (Get-LMDevice -Name $Result['DeviceName']).Id
                if (Test-LookupResult -Result $lookup -LookupString $Result['DeviceName']) {
                    throw "Unable to resolve device name '$($Result['DeviceName'])'."
                }
                $Result['DeviceId'] = [string]$lookup
            }
        }
        default {
            $Definition = $Script:LMSDTResourceWizardDefinitions[$ResourceType]
            if ($Result.ContainsKey($Definition.NameParam) -and -not $Result.ContainsKey($Definition.IdParam)) {
                $resource = & $Definition.GetByName $Result[$Definition.NameParam]
                if (Test-LookupResult -Result $resource -LookupString $Result[$Definition.NameParam]) {
                    throw "Unable to resolve $($Definition.Label) name '$($Result[$Definition.NameParam])'."
                }
                $Result[$Definition.IdParam] = [string]$resource.($Definition.IdProperty)
            }
        }
    }

    return $Result
}

function Test-LMSDTResourceIdentifiersValid {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Device', 'Collector', 'DeviceGroup', 'Website', 'WebsiteGroup', 'DeviceDatasource', 'DeviceDatasourceInstance')]
        [String]$ResourceType,

        [Parameter(Mandatory)]
        [hashtable]$BoundParameters
    )

    switch ($ResourceType) {
        'DeviceDatasource' {
            if (-not $BoundParameters.ContainsKey('DeviceDataSourceId') -or [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceDataSourceId'])) {
                throw 'DeviceDataSourceId is required.'
            }
        }
        'DeviceDatasourceInstance' {
            if (-not $BoundParameters.ContainsKey('DeviceDataSourceInstanceId') -or [string]::IsNullOrWhiteSpace([string]$BoundParameters['DeviceDataSourceInstanceId'])) {
                throw 'DeviceDataSourceInstanceId is required.'
            }
        }
        default {
            $Definition = $Script:LMSDTResourceWizardDefinitions[$ResourceType]
            $HasId = $BoundParameters.ContainsKey($Definition.IdParam) -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters[$Definition.IdParam])
            $HasName = $BoundParameters.ContainsKey($Definition.NameParam) -and -not [string]::IsNullOrWhiteSpace([string]$BoundParameters[$Definition.NameParam])
            if ($HasId -and $HasName) {
                throw "Provide either -$($Definition.IdParam) or -$($Definition.NameParam), not both."
            }
            if (-not $HasId -and -not $HasName) {
                throw "Either -$($Definition.IdParam) or -$($Definition.NameParam) is required."
            }
        }
    }
}
