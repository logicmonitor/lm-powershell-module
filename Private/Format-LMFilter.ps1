<#
.SYNOPSIS
Formats the LogicMonitor filter for API requests.

.DESCRIPTION
The Format-LMFilter function is used to format the LogicMonitor filter for API requests. It takes an input filter object and validates the field names against the API schema before formatting. The function supports both legacy hashtable and new string filter formats.

.PARAMETER Filter
The input filter object. It can be a hashtable or a string.

.PARAMETER ResourcePath
The API endpoint path (e.g., '/device/devices') used to validate filter fields against the schema.

.OUTPUTS
The formatted filter string.

.EXAMPLE
$filter = @{
    name = "MyMonitor"
    status = "active"
}
$formattedFilter = Format-LMFilter -Filter $filter -ResourcePath "/device/devices"
Write-Host $formattedFilter
# Output: name:"MyMonitor",status:"active"

.EXAMPLE
$filter = "name -eq 'MyMonitor' -and displayName -eq 'active'"
$formattedFilter = Format-LMFilter -Filter $filter -ResourcePath "/device/devices"
Write-Host $formattedFilter
# Output: name:"MyMonitor",displayName:"active"
#>

function Format-LMFilter {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$Filter,

        [Parameter(Mandatory)]
        [String]$ResourcePath
    )
    # Validate filter fields before formatting
    Test-LMFilterField -Filter $Filter -ResourcePath $ResourcePath
    
    $FormatedFilter = ""
    #Keep legacy filter method for backwards compatability
    if ($Filter -is [hashtable]) {
        $FormatedFilter = Format-LMFilter-v1 -Filter $Filter
        Write-Debug "Constructed Filter-v1: $FormatedFilter"
        return $FormatedFilter
    }
    else {
        #Split our filters in an array based on logical operator
        $FilterArray = [regex]::Split($Filter, '(\s+-and\s+|\s+-or\s+)')

        foreach ($Filter in $FilterArray) {
            if ($Filter -match '\s+-and\s+') {
                $FormatedFilter += ","
            }
            elseif ($Filter -match '\s+-or\s+') {
                $FormatedFilter += "||"
            }
            else {
                $SingleFilterArray = [regex]::Split($Filter, '(\s+-eq\s+|\s+-ne\s+|\s+-gt\s+|\s+-lt\s+|\s+-ge\s+|\s+-le\s+|\s+-contains\s+|\s+-notcontains\s+)')
                if (($SingleFilterArray | Measure-Object).Count -gt 1) {
                    foreach ($SingleFilter in $SingleFilterArray) {
                        if ($SingleFilter -match '(\s+-eq\s+|\s+-ne\s+|\s+-gt\s+|\s+-lt\s+|\s+-ge\s+|\s+-le\s+|\s+-contains\s+|\s+-notcontains\s+)') {
                            switch -Regex ($SingleFilter) {
                                '\s+-eq\s+' { $FormatedFilter += ":" }
                                '\s+-ne\s+' { $FormatedFilter += "!:" }
                                '\s+-gt\s+' { $FormatedFilter += ">" }
                                '\s+-lt\s+' { $FormatedFilter += "<" }
                                '\s+-ge\s+' { $FormatedFilter += ">:" }
                                '\s+-le\s+' { $FormatedFilter += "<:" }
                                '\s+-contains\s+' { $FormatedFilter += "~" }
                                '\s+-notcontains\s+' { $FormatedFilter += "!~" }
                                default { throw "[ERROR]: Invalid filter syntax: $Filter" }
                            }
                        }
                        else {
                            if ($SingleFilter -match "^(\s*)'(.*)'(\s*)$") {
                                $Leading = $Matches[1]
                                $Value = $Matches[2]
                                $Trailing = $Matches[3]
                                $EscapedValue = $Value.Replace('"', '\"')
                                $FormatedFilter += $Leading + '"' + $EscapedValue + '"' + $Trailing
                            }
                            else {
                                $FormatedFilter += $SingleFilter
                            }
                        }
                    }
                }
                else {
                    throw "[ERROR]: Invalid filter syntax: $SingleFilterArray"

                }
            }
        }

        #Escape reserved characters DEVTS-21125, limit to non filter characters, replace with URL encoded characters
        $FormatedFilter = $FormatedFilter.Replace("(", "%5C%28")
        $FormatedFilter = $FormatedFilter.Replace(")", "%5C%29")
        $FormatedFilter = $FormatedFilter.Replace("$", "%5C%24")
        $FormatedFilter = $FormatedFilter.Replace("&", "%5C%26")
        $FormatedFilter = $FormatedFilter.Replace("#", "%5C%23")
        $FormatedFilter = $FormatedFilter.Replace("[", "%5C%5B")
        $FormatedFilter = $FormatedFilter.Replace("]", "%5C%5D")

        #Apply patent pending double URL encoding to appease the API gods
        $FormatedFilter = [System.Web.HttpUtility]::UrlEncode($FormatedFilter)

        Write-Debug "Constructed Filter-v2: $FormatedFilter"
        return $FormatedFilter
    }
}