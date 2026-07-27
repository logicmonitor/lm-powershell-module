<#
.SYNOPSIS
Validates filter field names against the allowed fields for a given API endpoint.

.DESCRIPTION
The Test-LMFilterField function validates that all field names used in a filter
(either hashtable or string format) are valid for the specified API endpoint.
It loads the validation configuration from LMFilterValidationConfig.psd1 and
throws an error if invalid fields are found, with suggestions for similar valid fields.

.PARAMETER Filter
The filter object to validate. Can be a hashtable or a string.

.PARAMETER ResourcePath
The API endpoint path (e.g., '/device/devices') to validate against.

.EXAMPLE
Test-LMFilterField -Filter "displayname -eq 'test'" -ResourcePath "/device/devices"
Throws an error because 'displayname' should be 'displayName'.

.EXAMPLE
Test-LMFilterField -Filter @{displayName='test'} -ResourcePath "/device/devices"
Validates successfully as 'displayName' is a valid field.

.NOTES
This function is called internally by Format-LMFilter and should not typically
be called directly by users.
#>

function Test-LMFilterField {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [Object]$Filter,

        [Parameter(Mandatory)]
        [String]$ResourcePath
    )

    # Load validation config (cached at script scope)
    if (-not $Script:LMFilterValidationConfig) {
        $ConfigPath = Join-Path $PSScriptRoot "LMFilterValidationConfig.psd1"
        
        if (-not (Test-Path $ConfigPath)) {
            Write-Warning "Filter validation configuration not found at: $ConfigPath"
            Write-Warning "Run Build-LMFilterValidationConfig.ps1 to generate it."
            return # Skip validation if config doesn't exist
        }
        
        try {
            $Script:LMFilterValidationConfig = Import-PowerShellDataFile -Path $ConfigPath
            Write-Debug "Loaded filter validation config with $($Script:LMFilterValidationConfig.Count) endpoints"
        }
        catch {
            Write-Warning "Failed to load filter validation configuration: $_"
            return # Skip validation if config can't be loaded
        }
    }

    # Normalize ResourcePath - remove any path parameters like {id}
    $NormalizedPath = $ResourcePath -replace '/\{[^}]+\}', '/{id}'
    
    # Check if we have validation rules for this endpoint
    if (-not $Script:LMFilterValidationConfig.ContainsKey($NormalizedPath)) {
        Write-Debug "No validation rules found for endpoint: $NormalizedPath"
        return # Skip validation for endpoints without rules
    }

    $ValidFields = $Script:LMFilterValidationConfig[$NormalizedPath]
    Write-Debug "Validating against $($ValidFields.Count) valid fields for $NormalizedPath"

    # Extract field names from the filter
    $FilterFields = @()

    if ($Filter -is [hashtable]) {
        # Hashtable filter (v1 format)
        $FilterFields = $Filter.Keys
    }
    else {
        # String filter (v2 format) - extract field names before operators
        # Pattern: field_name followed by -eq, -ne, -gt, -lt, -ge, -le, -contains, -notcontains
        $Pattern = '(?:^|\s+)([a-zA-Z_][a-zA-Z0-9_\.]*)\s+(?:-eq|-ne|-gt|-lt|-ge|-le|-contains|-notcontains)\s+'
        $PatternMatches = [regex]::Matches($Filter, $Pattern)
        
        foreach ($Match in $PatternMatches) {
            if ($Match.Groups.Count -ge 2) {
                $FilterFields += $Match.Groups[1].Value
            }
        }
    }

    # Validate each field
    $InvalidFields = @()

    Write-Debug "Extracted $($FilterFields.Count) field(s) to validate: $($FilterFields -join ', ')"

    foreach ($Field in $FilterFields) {
        # Check if field is valid (case-sensitive)
        if ($ValidFields -cnotcontains $Field) {
            Write-Debug "Field '$Field' is NOT in valid fields list"
            $InvalidFields += $Field
        }
        else {
            Write-Debug "Field '$Field' is valid"
        }
    }

    # If we found invalid fields, throw an error with suggestions
    if ($InvalidFields.Count -gt 0) {
        $ErrorMessage = "Invalid filter field(s) for endpoint '$ResourcePath':`n"
        
        foreach ($InvalidField in $InvalidFields) {
            $ErrorMessage += "  - '$InvalidField'`n"
            
            # Try to find similar valid fields (case-insensitive match or Levenshtein distance)
            $Suggestions = @()
            
            # First try case-insensitive exact match
            $CaseInsensitiveMatch = $ValidFields | Where-Object { $_ -ieq $InvalidField }
            if ($CaseInsensitiveMatch) {
                $Suggestions += $CaseInsensitiveMatch
            }
            else {
                # Find fields that start with the same letters
                $StartsWith = $ValidFields | Where-Object { $_ -like "$InvalidField*" }
                if ($StartsWith) {
                    $Suggestions += $StartsWith | Select-Object -First 3
                }
                else {
                    # Find fields that contain the invalid field
                    $Contains = $ValidFields | Where-Object { $_ -like "*$InvalidField*" }
                    if ($Contains) {
                        $Suggestions += $Contains | Select-Object -First 3
                    }
                }
            }
            
            if ($Suggestions.Count -gt 0) {
                $ErrorMessage += "    Did you mean: $($Suggestions -join ', ')?`n"
            }
        }
        
        $ErrorMessage += "`nValid fields for this endpoint include:`n"
        $ErrorMessage += "  $($ValidFields[0..50] -join ', ')"
        if ($ValidFields.Count -gt 50) {
            $ErrorMessage += ", ... (and $($ValidFields.Count - 50) more)"
        }
        
        throw $ErrorMessage
    }

    Write-Debug "Filter validation passed for endpoint: $NormalizedPath"
}

