<#
.SYNOPSIS
Formats a hashtable for LogicMonitor API requests by removing blank or unspecified keys and converting to JSON.

.DESCRIPTION
Format-LMData processes a hashtable, removing keys with blank or null values unless they are specified to be kept via always-keep, conditional-keep, or conditional-value-keep rules. The resulting hashtable is then converted to JSON for use in API requests. The function also accepts a Context hashtable for use in conditional logic only; Context keys are not included in the final JSON output.

.PARAMETER Data
The hashtable to process and convert to JSON.

.PARAMETER UserSpecifiedKeys
Array of parameter names specified by the user (e.g., $MyInvocation.BoundParameters.Keys).

.PARAMETER AlwaysKeepKeys
Array of keys that should always be kept, regardless of value.

.PARAMETER ConditionalKeep
Hashtable mapping keys to parameter names; if the parameter is not specified, the key is removed.

.PARAMETER ConditionalValueKeep
Hashtable mapping keys to arrays of rules. Each rule specifies a value and a list of keys to keep if the value matches. The value is checked in the merged Data+Context hashtable.

.PARAMETER Context
A hashtable of extra values (such as parameters) to use for conditional logic only. Not included in final JSON.

.PARAMETER JsonDepth
Depth to use for ConvertTo-Json. Default is 10.

.EXAMPLE
$Json = Format-LMData -Data $Data -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys -AlwaysKeepKeys @('steps') -ConditionalKeep @{ 'name' = 'NewName' } -ConditionalValueKeep @{ 'type' = @(@{ Value = 'special'; KeepKeys = @('details') }) } -Context @{ type = $Type } -JsonDepth 5

#>
function Format-LMData {
    [CmdletBinding()]
    param(
        # The hashtable to process and convert to JSON
        [Parameter(Mandatory)]
        [hashtable]$Data,

        # Array of parameter names specified by the user (e.g., $MyInvocation.BoundParameters.Keys)
        [Parameter(Mandatory)]
        [string[]]$UserSpecifiedKeys,

        # Keys to always keep, regardless of value
        [string[]]$AlwaysKeepKeys = @(),

        # Hashtable mapping keys to parameter names; if the parameter is not specified, the key is removed
        [hashtable]$ConditionalKeep = @{},

        # Hashtable mapping keys to arrays of rules. Each rule specifies a value and a list of keys to keep if the value matches
        [hashtable]$ConditionalValueKeep = @{},

        # Hashtable of extra values (such as parameters) to use for conditional logic only. Not included in final JSON.
        [hashtable]$Context = @{},

        # Depth for ConvertTo-Json
        [int]$JsonDepth = 10
    )

    # Start with the always-keep keys
    $keysToAlwaysKeep = @($AlwaysKeepKeys)

    # Merge Data and Context for conditional logic
    $merged = @{}
    foreach ($k in $Data.Keys) { $merged[$k] = $Data[$k] }
    foreach ($k in $Context.Keys) { $merged[$k] = $Context[$k] }

    # Handle conditional value-based keeps using merged view
    foreach ($condKey in $ConditionalValueKeep.Keys) {
        $condValue = $merged[$condKey]
        foreach ($rule in $ConditionalValueKeep[$condKey]) {
            # If the value matches, add the specified keys to always-keep
            if ($condValue -eq $rule.Value) {
                $keysToAlwaysKeep += $rule.KeepKeys
            }
        }
    }

    # Iterate over a copy of the keys to avoid modifying the collection while iterating
    foreach ($key in @($Data.Keys)) {
        # Skip keys that should always be kept
        if ($keysToAlwaysKeep -contains $key) { continue }

        # Handle conditional keep: only keep if the required parameter was specified
        if ($ConditionalKeep.ContainsKey($key)) {
            $requiredParam = $ConditionalKeep[$key]
            if ($UserSpecifiedKeys -notcontains $requiredParam) { $Data.Remove($key) }
            continue
        }

        # Remove key if value is blank/null and it was not specified by the user
        if ([string]::IsNullOrEmpty($Data[$key]) -and ($UserSpecifiedKeys -notcontains $key)) {
            $Data.Remove($key)
        }
    }

    # Convert the cleaned hashtable to JSON
    return $Data | ConvertTo-Json -Depth $JsonDepth
}