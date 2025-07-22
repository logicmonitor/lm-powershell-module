<#
.SYNOPSIS
    Copies device properties from a source device to target device groups. Sensitive properties cannot be copied as their values are not available via API.

.DESCRIPTION
    The Copy-LMDevicePropertyToGroup function copies specified properties from a source device to one or more target device groups. The source device can be randomly selected from a group or explicitly specified. Properties are copied to the target groups while preserving other existing group properties.

.PARAMETER SourceDeviceId
    The ID of the source device to copy properties from. This parameter is part of the "SourceDevice" parameter set.

.PARAMETER SourceGroupId
    The ID of the source group to randomly select a device from. This parameter is part of the "SourceGroup" parameter set.

.PARAMETER TargetGroupId
    The ID of the target group(s) to copy properties to. Multiple group IDs can be specified.

.PARAMETER PropertyNames
    Array of property names to copy. These can be only be custom properties directly assigned to the device.

.PARAMETER PassThru
    If specified, returns the updated device group objects.

.EXAMPLE
    Copy-LMDevicePropertyToGroup -SourceDeviceId 123 -TargetGroupId 456 -PropertyNames "location","department"
    Copies the location and department properties from device 123 to group 456.

.EXAMPLE
    Copy-LMDevicePropertyToGroup -SourceGroupId 789 -TargetGroupId 456,457 -PropertyNames "location" -PassThru
    Randomly selects a device from group 789 and copies its location property to groups 456 and 457, returning the updated groups.

.NOTES
    Requires an active Logic Monitor session. Use Connect-LMAccount to log in before running this function.
#>
function Copy-LMDevicePropertyToGroup {
    [CmdletBinding(DefaultParameterSetName = "SourceDevice")]
    param(
        [Parameter(Mandatory, ParameterSetName = "SourceDevice", ValueFromPipelineByPropertyName)]
        [String]$SourceDeviceId,

        [Parameter(Mandatory, ParameterSetName = "SourceGroup")]
        [String]$SourceGroupId,

        [Parameter(Mandatory)]
        [String[]]$TargetGroupId,

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
            foreach ($groupId in $TargetGroupId) {
                $group = Get-LMDeviceGroup -Id $groupId
                if (!$group) {
                    Write-Warning "Target group with ID $groupId not found, skipping..."
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
                    Write-Information "[INFO]: Copying properties to group $($group.name) (ID: $groupId)"
                    $updatedGroup = Set-LMDeviceGroup -Id $groupId -Properties $propertiesToCopy

                    Write-Information "[INFO]: Added properties to $($group.name):"
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