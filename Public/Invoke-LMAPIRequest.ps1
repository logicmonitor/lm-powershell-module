<#
.SYNOPSIS
Executes a custom LogicMonitor API request with full control over endpoint and payload.

.DESCRIPTION
The Invoke-LMAPIRequest function provides advanced users with direct access to the LogicMonitor API
while leveraging the module's authentication, retry logic, debug utilities, and error handling.
This is useful for accessing API endpoints that don't yet have dedicated cmdlets in the module.

.PARAMETER ResourcePath
The API resource path (e.g., "/device/devices", "/setting/integrations/123").
Do not include the base URL or query parameters here.

.PARAMETER Method
The HTTP method to use. Valid values: GET, POST, PATCH, PUT, DELETE.

.PARAMETER QueryParams
Optional hashtable of query parameters to append to the request URL.
Example: @{ size = 100; offset = 0; filter = 'name:"test"' }

.PARAMETER Data
Optional hashtable containing the request body data. Will be automatically converted to JSON.
Use this for POST, PATCH, and PUT requests.

.PARAMETER RawBody
Optional raw string body to send with the request. Use this instead of -Data when you need
complete control over the request body format. Mutually exclusive with -Data.

.PARAMETER Version
The X-Version header value for the API request. Defaults to 3.
Some newer API endpoints may require different version numbers.

.PARAMETER ContentType
The Content-Type header for the request. Defaults to "application/json".

.PARAMETER MaxRetries
Maximum number of retry attempts for transient errors. Defaults to 3.
Set to 0 to disable retries.

.PARAMETER NoRetry
Switch to completely disable retry logic and fail immediately on any error.

.PARAMETER OutFile
Path to save the response content to a file. Useful for downloading reports or exports.

.PARAMETER TypeName
Optional type name to add to the returned objects (e.g., "LogicMonitor.CustomResource").
This enables proper formatting if you have custom format definitions.

.PARAMETER AsHashtable
Switch to return the response as a hashtable instead of a PSCustomObject.

.EXAMPLE
# Get a custom resource not yet supported by a dedicated cmdlet
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method GET

.EXAMPLE
# Create a resource with custom payload
$data = @{
    name = "My Integration"
    type = "slack"
    url = "https://hooks.slack.com/services/..."
}
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method POST -Data $data

.EXAMPLE
# Create a device with custom properties (note the array format)
$data = @{
    name = "server1"
    displayName = "Production Server"
    preferredCollectorId = 5
    customProperties = @(
        @{ name = "environment"; value = "production" }
        @{ name = "owner"; value = "ops-team" }
    )
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method POST -Data $data

.EXAMPLE
# Update a resource with PATCH
$updates = @{
    description = "Updated description"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices/123" -Method PATCH -Data $updates

.EXAMPLE
# Delete a resource
Invoke-LMAPIRequest -ResourcePath "/setting/integrations/456" -Method DELETE

.EXAMPLE
# Get with query parameters and custom version
$queryParams = @{
    size = 500
    filter = 'status:"active"'
    fields = "id,name,status"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams $queryParams -Version 3

.EXAMPLE
# Use raw body for special formatting requirements
$rawJson = '{"name":"test","customField":null}'
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint" -Method POST -RawBody $rawJson

.EXAMPLE
# Download a report to file
Invoke-LMAPIRequest -ResourcePath "/report/reports/123/download" -Method GET -OutFile "C:\Reports\report.pdf"

.EXAMPLE
# Format output as table
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET | Format-Table id, name, displayName, status

# Use existing format definition
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -TypeName "LogicMonitor.Device"

.EXAMPLE
# Get paginated results manually
$offset = 0
$size = 1000
$allResults = @()
do {
    $response = Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams @{ size = $size; offset = $offset }
    $allResults += $response.items
    $offset += $size
} while ($allResults.Count -lt $response.total)

.NOTES
You must run Connect-LMAccount before running this command.

This cmdlet is designed for advanced users who need to:
- Access API endpoints not yet covered by dedicated cmdlets
- Test new API features or beta endpoints
- Implement custom workflows requiring direct API access
- Prototype new functionality before requesting cmdlet additions

For standard operations, use the dedicated cmdlets (Get-LMDevice, New-LMDevice, etc.) as they
provide better parameter validation, documentation, and user experience.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns the API response as a PSCustomObject by default, or as specified by -AsHashtable.
#>
function Invoke-LMAPIRequest {

    [CmdletBinding(DefaultParameterSetName = 'Data', SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [String]$ResourcePath,

        [Parameter(Mandatory)]
        [ValidateSet("GET", "POST", "PATCH", "PUT", "DELETE")]
        [String]$Method,

        [Hashtable]$QueryParams,

        [Parameter(ParameterSetName = 'Data')]
        [Hashtable]$Data,

        [Parameter(ParameterSetName = 'RawBody')]
        [String]$RawBody,

        [ValidateRange(1, 10)]
        [Int]$Version = 3,

        [String]$ContentType = "application/json",

        [ValidateRange(0, 10)]
        [Int]$MaxRetries = 3,

        [Switch]$NoRetry,

        [String]$OutFile,

        [String]$TypeName,

        [Switch]$AsHashtable
    )

    #Check if we are logged in and have valid api creds
    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    # Ensure ResourcePath starts with /
    if (-not $ResourcePath.StartsWith('/')) {
        $ResourcePath = '/' + $ResourcePath
    }

    # Build the request body
    $Body = $null
    if ($PSCmdlet.ParameterSetName -eq 'Data' -and $Data) {
        # Convert hashtable to JSON
        $Body = $Data | ConvertTo-Json -Depth 10 -Compress
    }
    elseif ($PSCmdlet.ParameterSetName -eq 'RawBody' -and $RawBody) {
        $Body = $RawBody
    }

    # Build query string from QueryParams hashtable
    $QueryString = ""
    if ($QueryParams -and $QueryParams.Count -gt 0) {
        $queryParts = @()
        foreach ($key in $QueryParams.Keys) {
            $value = $QueryParams[$key]
            if ($null -ne $value) {
                # URL encode the value
                $encodedValue = [System.Web.HttpUtility]::UrlEncode($value.ToString())
                $queryParts += "$key=$encodedValue"
            }
        }
        if ($queryParts.Count -gt 0) {
            $QueryString = "?" + ($queryParts -join "&")
        }
    }

    # Build the full URI
    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryString

    # Create a message for ShouldProcess
    $operationDescription = switch ($Method) {
        "GET" { "Retrieve from" }
        "POST" { "Create resource at" }
        "PATCH" { "Update resource at" }
        "PUT" { "Replace resource at" }
        "DELETE" { "Delete resource at" }
    }

    # Adjust ConfirmImpact based on method
    $shouldProcessTarget = $ResourcePath
    $shouldProcessAction = $operationDescription

    # Determine if we should prompt based on method
    # GET requests should never prompt unless explicitly requested
    # DELETE requests should always prompt unless explicitly suppressed
    $shouldPrompt = $true
    if ($Method -eq "GET") {
        # For GET, only process if -Confirm was explicitly passed
        if ($PSBoundParameters.ContainsKey('Confirm')) {
            $shouldPrompt = $PSCmdlet.ShouldProcess($shouldProcessTarget, $shouldProcessAction)
        }
        else {
            $shouldPrompt = $true  # Skip ShouldProcess for GET
        }
    }
    elseif ($Method -eq "DELETE") {
        # For DELETE, always use ShouldProcess with High impact
        $shouldPrompt = $PSCmdlet.ShouldProcess($shouldProcessTarget, $shouldProcessAction, "Are you sure you want to delete this resource?")
    }
    else {
        # For POST, PATCH, PUT use normal ShouldProcess
        $shouldPrompt = $PSCmdlet.ShouldProcess($shouldProcessTarget, $shouldProcessAction)
    }

    if ($shouldPrompt) {
        
        # Generate headers with custom version
        $Headers = New-LMHeader -Auth $Script:LMAuth -Method $Method -ResourcePath $ResourcePath -Data $Body -Version $Version -ContentType $ContentType

        # Output debug information
        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

        # Build parameters for Invoke-LMRestMethod
        $restParams = @{
            Uri              = $Uri
            Method           = $Method
            Headers          = $Headers[0]
            WebSession       = $Headers[1]
            CallerPSCmdlet   = $PSCmdlet
        }

        if ($Body) {
            $restParams.Body = $Body
        }

        if ($OutFile) {
            $restParams.OutFile = $OutFile
        }

        if ($MaxRetries -eq 0 -or $NoRetry) {
            $restParams.NoRetry = $true
        }
        else {
            $restParams.MaxRetries = $MaxRetries
        }

        # Issue request
        $Response = Invoke-LMRestMethod @restParams

        # Handle the response
        if ($null -eq $Response) {
            return $null
        }

        # If OutFile was specified, the response is already saved
        if ($OutFile) {
            Write-Verbose "Response saved to: $OutFile"
            return [PSCustomObject]@{
                Success = $true
                FilePath = $OutFile
                Message = "Response saved successfully"
            }
        }

        # Return the items array if it exists, otherwise return the response object
        if ($Response.items) {
            $Response = $Response.items
        }

        # Add type information if specified
        if ($TypeName) {
            $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName $TypeName
        }

        # Convert to hashtable if requested
        if ($AsHashtable -and $Response) {
            if ($Response -is [Array]) {
                return $Response | ForEach-Object {
                    $hashtable = @{}
                    $_.PSObject.Properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
                    $hashtable
                }
            }
            else {
                $hashtable = @{}
                $Response.PSObject.Properties | ForEach-Object { $hashtable[$_.Name] = $_.Value }
                return $hashtable
            }
        }

        return $Response
    }
}

