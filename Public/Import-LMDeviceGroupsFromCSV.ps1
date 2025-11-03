<#
.SYNOPSIS
Imports list of device groups based on specified CSV file.

.DESCRIPTION
Imports list of device groups based on specified CSV file. You can generate a sample of the CSV file by specifying the -GenerateExampleCSV parameter.

.PARAMETER FilePath
Path to the CSV file containing device groups to import. Required for Import parameter set.

.PARAMETER GenerateExampleCSV
Generates a sample CSV file to use as a template for importing device groups.

.PARAMETER PassThru
Returns the imported device group objects. By default, no output is returned.

.EXAMPLE
Import-LMDeviceGroupsFromCSV -FilePath ./ImportList.csv -PassThru

.NOTES
Assumes csv with the headers name,fullpath,description,appliesTo,property1,property2,property[n]. Name and fullpath are the only required fields.

.INPUTS
None. Does not accept pipeline input.
#>
function Import-LMDeviceGroupsFromCSV {
    [CmdletBinding(DefaultParameterSetName = "Import")]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Import")]
        [ValidateScript({ Test-Path $_ })]
        [String]$FilePath,

        [Parameter(ParameterSetName = "Sample")]
        [Switch]$GenerateExampleCSV,

        [Parameter(ParameterSetName = "Import")]
        [Switch]$PassThru
    )

    #Check if we are logged in and have valid api creds
    begin {
        $Results = New-Object System.Collections.ArrayList
    }
    process {
        if ($GenerateExampleCSV) {
            $SampleCSV = ("name,fullpath,description,appliesTo,property.name1,property.name2").Split(",")

            $SampleContent = New-Object System.Collections.ArrayList
            $SampleContent.Add([PSCustomObject]@{
                    $SampleCSV[0] = "California"
                    $SampleCSV[1] = "Locations/North America"
                    $SampleCSV[2] = "My sample device group for CA"
                    $SampleCSV[3] = 'system.displayName =~ "CA-*" && isDevice()'
                    $SampleCSV[4] = "property value 1"
                    $SampleCSV[5] = "property value 2"
                }) | Out-Null
            $SampleContent.Add([PSCustomObject]@{
                    $SampleCSV[0] = "New York"
                    $SampleCSV[1] = "Locations/North America"
                    $SampleCSV[2] = "My sample device group for NY"
                    $SampleCSV[3] = 'system.displayName =~ "NY-*" && isDevice()'
                    $SampleCSV[4] = "property value 1"
                    $SampleCSV[5] = "property value 2"
                }) | Out-Null
            $SampleContent.Add([PSCustomObject]@{
                    $SampleCSV[0] = "London"
                    $SampleCSV[1] = "Locations/Europe"
                    $SampleCSV[2] = "My sample device group for London"
                    $SampleCSV[3] = 'system.displayName =~ "LONDON-*" && isDevice()'
                    $SampleCSV[4] = "property value 1"
                    $SampleCSV[5] = "property value 2"
                }) | Out-Null

            $SampleContent | Export-Csv "SampleLMDeviceGroupImportCSV.csv" -Force -NoTypeInformation
            Write-Information "[INFO]: Saved sample CSV (SampleLMDeviceGroupImportCSV.csv) to current directory."
            return
        }
        if ($Script:LMAuth.Valid) {
            $GroupList = Import-Csv -Path $FilePath

            if ($GroupList) {
                #Get property headers for adding to property hashtable
                $PropertyHeaders = ($GroupList | Get-Member -MemberType NoteProperty).Name | Where-Object { $_ -notmatch "name|fullpath|description|appliesTo" }

                $i = 1
                $GroupCount = ($GroupList | Measure-Object).Count

                #Loop through device list and add to portal
                foreach ($DeviceGroup in $GroupList) {
                    Write-Progress -Activity "Processing Group Import: $($DeviceGroup.name)" -Status "$([Math]::Floor($($i/$GroupCount*100)))% Completed" -PercentComplete $($i / $GroupCount * 100) -Id 0
                    $Properties = @{}
                    foreach ($Property in $PropertyHeaders) {
                        $Value = $DeviceGroup."$Property"
                        if (-not [string]::IsNullOrWhiteSpace($Value)) {
                            $Properties.Add($Property, $DeviceGroup."$Property")
                        }
                        else {
                            Write-Debug "Skipping adding property $Property since null for $($DeviceGroup.name)"
                        }
                    }
                    try {
                        $CurrentGroup = $DeviceGroup.fullpath.Replace("\", "/") #Replace backslashes with forward slashes for LM API
                        $GroupId = (Get-LMDeviceGroup | Where-Object { $_.fullpath -eq $CurrentGroup }).Id
                        if (!$GroupId) {
                            $GroupPaths = $DeviceGroup.fullpath.Split("/")
                            $j = 1
                            $GroupPathsCount = ($GroupPaths | Measure-Object).Count
                            foreach ($Path in $GroupPaths) {
                                Write-Progress -Activity "Processing Parent Group Creation: $CurrentGroup" -Status "$([Math]::Floor($($j/$GroupPathsCount*100)))% Completed" -PercentComplete $($j / $GroupPathsCount * 100) -ParentId 0 -Id 1
                                $GroupId = New-LMDeviceGroupFromPath -Path $Path -PreviousGroupId $GroupId
                                $j++
                            }
                        }
                        $DeviceGroup = New-LMDeviceGroup -name $DeviceGroup.name -Description $DeviceGroup.description -ParentGroupId $GroupId -Properties $Properties -AppliesTo $DeviceGroup.appliesTo -ErrorAction Stop
                        $Results.Add($DeviceGroup) | Out-Null
                        $i++
                    }
                    catch {
                        Write-Error "[ERROR]: Unable to add device $($DeviceGroup.name) to portal: $_"
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