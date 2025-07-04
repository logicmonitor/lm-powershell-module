<#
.SYNOPSIS
Imports devices from a CSV file into LogicMonitor.

.DESCRIPTION
The Import-LMDevicesFromCSV function imports devices from a CSV file into LogicMonitor. It requires a valid CSV file containing device information such as IP address, display name, host group, collector ID, and description. The function checks if the user is logged in and has valid API credentials before importing the devices.

.PARAMETER FilePath
Specifies the path to the CSV file containing the device information. This parameter is mandatory when the 'Import' parameter set is used.

.PARAMETER GenerateExampleCSV
Generates an example CSV file with sample device information. This parameter is optional and can be used with the 'Sample' parameter set.

.PARAMETER PassThru
Indicates whether to return the imported devices as output. This parameter is optional and can be used with the 'Import' parameter set.

.PARAMETER CollectorId
Specifies the collector ID to assign to the imported devices. This parameter is optional and can be used with the 'Import' parameter set.

.PARAMETER AutoBalancedCollectorGroupId
Specifies the auto-balanced collector group ID to assign to the imported devices. This parameter is optional and can be used with the 'Import' parameter set.

.EXAMPLE
Import-LMDevicesFromCSV -FilePath "C:\Devices.csv" -CollectorId 1234
Imports devices from the "Devices.csv" file located at "C:\Devices.csv" and assigns the collector with ID 1234 to the imported devices.

.EXAMPLE
Import-LMDevicesFromCSV -GenerateExampleCSV
Generates an example CSV file named "SampleLMDeviceImportCSV.csv" in the current directory with sample device information.

.NOTES
- This function requires valid API credentials to connect to LogicMonitor.
- The CSV file must have the following columns: ip, displayname, hostgroup. collectorid, collectorgroupid, description, property.name1, property.name2.. are optional.
- The function creates device groups if they don't exist based on the host group path specified in the CSV file.
- If the collector ID is not specified in the CSV file, the function uses the collector ID specified by the CollectorId parameter.
#>

function Import-LMDevicesFromCSV {
    [CmdletBinding(DefaultParameterSetName = "Import")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Import")]
        [ValidateScript({ Test-Path $_ })]
        [String]$FilePath,

        [Parameter(ParameterSetName = "Sample")]
        [Switch]$GenerateExampleCSV,

        [Parameter(ParameterSetName = "Import")]
        [Switch]$PassThru,

        [Parameter(ParameterSetName = "Import")]
        [Nullable[Int]]$CollectorId,

        [Parameter(ParameterSetName = "Import")]
        [Nullable[Int]]$AutoBalancedCollectorGroupId


    )
    #Check if we are logged in and have valid api creds
    begin {
        $Results = New-Object System.Collections.ArrayList
    }
    process {
        if ($GenerateExampleCSV) {
            $SampleCSV = ("ip,displayname,hostgroup,collectorid,abcgid,description,snmp.community,property.name1,property.name2").Split(",")

            [PSCustomObject]@{
                $SampleCSV[0] = "192.168.1.1"
                $SampleCSV[1] = "SampleDeviceName"
                $SampleCSV[2] = "Full/Path/To/Resource"
                $SampleCSV[3] = "0"
                $SampleCSV[4] = "$null"
                $SampleCSV[5] = "My sample device"
                $SampleCSV[6] = "public"
                $SampleCSV[7] = "property value 1"
                $SampleCSV[8] = "property value 2"
            } | Export-Csv "SampleLMDeviceImportCSV.csv" -Force -NoTypeInformation

            Write-Information "[INFO]: Saved sample CSV (SampleLMDeviceImportCSV.csv) to current directory."

            return
        }
        if ($Script:LMAuth.Valid) {
            $DeviceList = Import-Csv -Path $FilePath

            if ($DeviceList) {
                #Get property headers for adding to property hashtable
                $PropertyHeaders = ($DeviceList | Get-Member -MemberType NoteProperty).Name | Where-Object { $_ -notmatch "ip|displayname|hostgroup|collectorid|abcgid|description" }

                $i = 1
                $DeviceCount = ($DeviceList | Measure-Object).Count

                #Loop through device list and add to portal
                foreach ($Device in $DeviceList) {
                    Write-Progress -Activity "Processing Device Import: $($Device.displayname)" -Status "$([Math]::Floor($($i/$DeviceCount*100)))% Completed" -PercentComplete $($i / $DeviceCount * 100) -Id 0
                    $Properties = @{}
                    foreach ($Property in $PropertyHeaders) {
                        $Value = $Device."$Property"
                        if (-not [string]::IsNullOrWhiteSpace($Value)) {
                            $Properties.Add($Property, $Value)
                        }
                        else {
                            Write-Debug "Skipping adding property $Property since null for $($Device.displayName)"
                        }
                    }
                    try {
                        $CurrentGroup = $Device.hostgroup.Replace("\", "/") #Replace backslashes with forward slashes for LM API
                        $GroupId = (Get-LMDeviceGroup | Where-Object { $_.fullpath -eq $CurrentGroup }).Id
                        if (!$GroupId) {
                            $GroupPaths = $Device.hostgroup.Split("/")
                            $j = 1
                            $GroupPathsCount = ($GroupPaths | Measure-Object).Count
                            foreach ($Path in $GroupPaths) {
                                Write-Progress -Activity "Processing Group Creation: $CurrentGroup" -Status "$([Math]::Floor($($j/$GroupPathsCount*100)))% Completed" -PercentComplete $($j / $GroupPathsCount * 100) -ParentId 0 -Id 1
                                $GroupId = New-LMDeviceGroupFromPath -Path $Path -PreviousGroupId $GroupId
                                $j++
                            }
                        }

                        #Parameter takes precedence over csv value
                        if (!$CollectorId) { $SetCollectorId = $Device.collectorid }else { $SetCollectorId = $CollectorId }

                        #Parameter takes precedence over csv value
                        if (!$AutoBalancedCollectorGroupId) { $SetAutoBalancedCollectorGroupId = $Device.abcgid }else { $SetAutoBalancedCollectorGroupId = $AutoBalancedCollectorGroupId }

                        if ($null -eq $SetCollectorId) {
                            Write-Error "[ERROR]: CollectorId is required for device import, please ensure you have a valid collector id in your csv file."
                            break
                        }

                        $DeviceParams = @{
                            Name                         = $Device.ip
                            DisplayName                  = $Device.displayname
                            Description                  = $Device.description
                            PreferredCollectorId         = $SetCollectorId
                            AutoBalancedCollectorGroupId = $SetAutoBalancedCollectorGroupId
                            HostGroupIds                 = $GroupId
                            Properties                   = $Properties
                            ErrorAction                  = "Stop"
                        }

                        #Remove empty values from hashtable
                        @($DeviceParams.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($DeviceParams[$_])) { $DeviceParams.Remove($_) } }

                        $Device = New-LMDevice @DeviceParams
                        $Results.Add($Device) | Out-Null
                        $i++
                    }
                    catch {
                        Write-Error "[ERROR]: Unable to add device $($Device.displayname) to portal: $_"
                    }
                }
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {
        return $(if ($PassThru) { $Results }else { $Null })
    }
}