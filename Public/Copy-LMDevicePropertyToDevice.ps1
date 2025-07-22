<#
.SYNOPSIS
    Copies device properties from a source device to target devices. Sensitive properties cannot be copied as their values are not available via API.

.DESCRIPTION
    The Copy-LMDevicePropertyToDevice function copies specified properties from a source device to one or more target devices. The source device can be randomly selected from a group or explicitly specified. Properties are copied to the targets while preserving other existing device properties.

.PARAMETER SourceDeviceId
    The ID of the source device to copy properties from. This parameter is part of the "SourceDevice" parameter set.

.PARAMETER SourceGroupId
    The ID of the source group to randomly select a device from. This parameter is part of the "SourceGroup" parameter set.

.PARAMETER TargetDeviceId
    The ID of the target device(s) to copy properties to. Multiple device IDs can be specified.

.PARAMETER PropertyNames
    Array of property names to copy. These can be only be custom properties directly assigned to the device.

.PARAMETER PassThru
    If specified, returns the updated device objects.

.EXAMPLE
    Copy-LMDevicePropertyToDevice -SourceDeviceId 123 -TargetDeviceId 456 -PropertyNames "location","department"
    Copies the location and department properties from device 123 to device 456.

.EXAMPLE
    Copy-LMDevicePropertyToDevice -SourceGroupId 789 -TargetDeviceId 456,457 -PropertyNames "location" -PassThru
    Randomly selects a device from group 789 and copies its location property to devices 456 and 457, returning the updated devices.

.NOTES
    Requires an active Logic Monitor session. Use Connect-LMAccount to log in before running this function.
#>
function Copy-LMDevicePropertyToDevice {
    [CmdletBinding(DefaultParameterSetName = "SourceDevice")]
    param(
        [Parameter(Mandatory, ParameterSetName = "SourceDevice", ValueFromPipelineByPropertyName)]
        [String]$SourceDeviceId,

        [Parameter(Mandatory, ParameterSetName = "SourceGroup")]
        [String]$SourceGroupId,

        [Parameter(Mandatory)]
        [String[]]$TargetDeviceId,

        [Parameter(Mandatory)]
        [String[]]$PropertyNames,

        [Switch]$PassThru
    )

    begin {
        if ($Script:LMAuth.Valid) {}
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }
    }

    process {
        try {
            # Get source device either directly or from group
            if ($PSCmdlet.ParameterSetName -eq "SourceDevice") {
                $sourceDevice = Get-LMDevice -Id $SourceDeviceId
                if (!$sourceDevice) {
                    Write-Error "Source device with ID $SourceDeviceId not found"
                    return
                }
            }
            else {
                $devices = Get-LMDeviceGroupDevice -Id $SourceGroupId
                if (!$devices) {
                    Write-Error "No devices found in source group with ID $SourceGroupId"
                    return
                }
                $sourceDevice = $devices | Get-Random
            }

            # Initialize results array if PassThru specified
            $results = New-Object System.Collections.ArrayList

            # Define sensitive patterns
            $sensitivePatterns = @(
                'credential$',
                'password$',
                '\S+\.pass$',
                '\S+\.auth$',
                '\S+\.key$',
                '\S+\.privtoken$',
                '\S+\.authtoken$',
                '\S+\.community$',
                '\S+\.accesskey$',
                '\S+\.secretkey$',
                '\S+\.privatekey$',
                '\S+\.serviceaccountkey$',
                '\S+\.awsaccesskey$',
                '\S+\.awssecretkey$',
                '\S+\.refreshtoken$',
                '\S+\.accesstoken$',
                '\d+\.snmptrap\.community$',
                '\d+\.snmptrap\.privtoken$',
                '\d+\.snmptrap\.authtoken$'
            )

            # Process each target group
            foreach ($deviceId in $TargetDeviceId) {
                $device = Get-LMDevice -Id $deviceId
                if (!$device) {
                    Write-Warning "Target device with ID $deviceId not found, skipping..."
                    continue
                }

                # Build properties hashtable
                $propertiesToCopy = @{}
                foreach ($propName in $PropertyNames) {
                    if ($propName -like 'system.*' -or $propName -like 'auto.*') {
                        Write-Warning "Property $propName is a system or auto property and cannot be set on device groups. Skipping copy."
                        continue
                    }
                    $isSensitive = $false
                    foreach ($pattern in $sensitivePatterns) {
                        if ($propName -match $pattern) {
                            $isSensitive = $true
                            break
                        }
                    }
                    if ($isSensitive) {
                        Write-Warning "Property $propName is a sensitive credential property and its value is masked by the API. Skipping copy."
                        continue
                    }
                    # Check custom properties
                    $propValue = $null
                    if ($sourceDevice.customProperties.name -contains $propName) {
                        $propValue = $sourceDevice.customProperties[$sourceDevice.customProperties.name.IndexOf($propName)].value
                    }
                    if ($propValue) {
                        $propertiesToCopy[$propName] = $propValue
                    }
                    else {
                        Write-Warning "Property $propName not found on source device $($sourceDevice.id), skipping..."
                    }
                }

                if ($propertiesToCopy.Count -gt 0) {
                    Write-Information "[INFO]: Copying properties to group $($device.name) (ID: $deviceId)"
                    $updatedGroup = Set-LMDevice -Id $deviceId -Properties $propertiesToCopy

                    Write-Information "[INFO]: Added properties to $($device.displayName):"
                    $propertiesToCopy.GetEnumerator() | ForEach-Object {
                        Write-Information ("  {0} = {1}" -f $_.Key, $_.Value)
                    }

                    if ($PassThru) {
                        $results.Add($updatedGroup) | Out-Null
                    }
                }
            }
        }
        catch {
            Write-Error "Error copying properties: $_"
        }
    }

    end {
        if ($PassThru) {
            return $results
        }
    }
}