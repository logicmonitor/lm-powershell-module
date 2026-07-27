<#
.SYNOPSIS
    This function formats a filter for Logic Monitor API calls (legacy v1 format).

.DESCRIPTION
    The Format-LMFilter-v1 function takes a hashtable of filter properties and formats them into a filter string.
    This is the legacy format for hashtable-based filters. Field validation is performed by the parent Format-LMFilter function.

.PARAMETER Filter
    A hashtable of filter properties. This is a mandatory parameter.

.EXAMPLE
    Format-LMFilter-v1 -Filter @{name='test'; displayName='Test Device'}

    This command formats the filter properties represented by the $Filter hashtable into a filter string.

.INPUTS
    System.Collections.Hashtable. You can pipe a hashtable of filter properties to Format-LMFilter-v1.

.OUTPUTS
    System.String. The function returns a string that represents the formatted filter.

.NOTES
    This function is called internally by Format-LMFilter for hashtable filters.
    Field validation is performed before this function is called.
#>
function Format-LMFilter-v1 {
    [CmdletBinding()]
    param (
        [Hashtable]$Filter
    )

    #Initalize variable for final filter string
    $FilterString = ""

    #Create filter string from hash table and url encode
    foreach ($Key in $($Filter.keys)) {
        $FilterString += $Key + ":" + "`"$($Filter[$Key])`"" + ","
    }
    $FilterString = $FilterString.trimend(',')

    return $FilterString
}