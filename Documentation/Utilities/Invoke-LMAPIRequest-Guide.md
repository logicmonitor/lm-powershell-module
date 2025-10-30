# Invoke-LMAPIRequest - Advanced User Guide

## Overview

`Invoke-LMAPIRequest` is a universal API request cmdlet designed for advanced users who need direct access to LogicMonitor API endpoints that don't yet have dedicated cmdlets in the module. It provides full control over API requests while leveraging the module's robust infrastructure.

## Why Use This Cmdlet?

### Problem Statement
With over 200+ cmdlets in the Logic.Monitor module, we still don't cover every API endpoint. Advanced users who discover new endpoints in the LogicMonitor API documentation often have to:
- Reinvent authentication handling
- Implement retry logic for transient failures
- Handle rate limiting manually
- Build debug utilities from scratch
- Deal with error handling inconsistencies

### Solution
`Invoke-LMAPIRequest` provides a "bring your own endpoint" approach that:
- ✅ Uses existing module authentication (API keys, Bearer tokens, Session sync)
- ✅ Leverages built-in retry logic with exponential backoff
- ✅ Integrates with module debug utilities (`-Debug`, `Resolve-LMDebugInfo`)
- ✅ Handles rate limiting automatically
- ✅ Provides consistent error handling
- ✅ Supports all HTTP methods (GET, POST, PATCH, PUT, DELETE)
- ✅ Allows custom API version headers
- ✅ Includes ShouldProcess support for safety

## Key Features

### 1. Full CRUD Operation Support
```powershell
# CREATE - POST
$data = @{ name = "New Resource"; type = "custom" }
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint" -Method POST -Data $data

# READ - GET
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint/123" -Method GET

# UPDATE - PATCH
$updates = @{ description = "Updated" }
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint/123" -Method PATCH -Data $updates

# DELETE
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint/123" -Method DELETE
```

**Important:** You must format data according to the API's requirements. For example, `customProperties` must be an array:
```powershell
# ❌ Wrong - simple hashtable
$data = @{
    name = "device1"
    customProperties = @{ prop1 = "value1" }
}

# ✅ Correct - array of name/value objects
$data = @{
    name = "device1"
    customProperties = @(
        @{ name = "prop1"; value = "value1" }
        @{ name = "prop2"; value = "value2" }
    )
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method POST -Data $data
```

### 2. Query Parameter Support
```powershell
$queryParams = @{
    size = 1000
    offset = 0
    filter = 'status:"active"'
    fields = "id,name,status,created"
    sort = "+name"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams $queryParams
```

### 3. Custom API Versions
Some newer LogicMonitor API endpoints require different version numbers:
```powershell
# Use API version 4 for newer endpoints
Invoke-LMAPIRequest -ResourcePath "/new/endpoint" -Method GET -Version 4
```

### 4. Raw Body Control
For special cases where you need exact control over JSON formatting:
```powershell
$rawJson = @"
{
    "name": "test",
    "customField": null,
    "preservedFormatting": true
}
"@
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method POST -RawBody $rawJson
```

### 5. File Downloads
```powershell
# Download reports or exports
Invoke-LMAPIRequest -ResourcePath "/report/reports/123/download" -Method GET -OutFile "C:\Reports\monthly.pdf"
```

### 6. Manual Pagination
```powershell
function Get-AllDevicesManually {
    $offset = 0
    $size = 1000
    $allResults = @()
    
    do {
        $response = Invoke-LMAPIRequest `
            -ResourcePath "/device/devices" `
            -Method GET `
            -QueryParams @{ size = $size; offset = $offset; sort = "+id" }
        
        $allResults += $response.items
        $offset += $size
        Write-Progress -Activity "Fetching devices" -Status "$($allResults.Count) of $($response.total)"
    } while ($allResults.Count -lt $response.total)
    
    return $allResults
}
```

### 7. Type Information
Add custom type names for proper formatting:
```powershell
$result = Invoke-LMAPIRequest `
    -ResourcePath "/custom/endpoint" `
    -Method GET `
    -TypeName "LogicMonitor.CustomResource"
```

### 8. Hashtable Output
For easier property manipulation:
```powershell
$result = Invoke-LMAPIRequest `
    -ResourcePath "/device/devices/123" `
    -Method GET `
    -AsHashtable

$result["customProperty"] = "newValue"
```

### 9. Formatting Output
Control how API responses are displayed:
```powershell
# Default: Returns raw objects (PowerShell chooses format automatically)
$devices = Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET

# For table view, pipe to Format-Table with specific properties
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET | 
    Format-Table id, name, displayName, status, collectorId

# Or use Select-Object to choose properties, then let PowerShell format
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET | 
    Select-Object id, name, displayName, status | 
    Format-Table -AutoSize

# For detailed view of a single item
Invoke-LMAPIRequest -ResourcePath "/device/devices/123" -Method GET | Format-List

# Use custom type name to leverage existing format definitions
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -TypeName "LogicMonitor.Device"
# This will use the LogicMonitor.Device format definition from Logic.Monitor.Format.ps1xml

# Pipeline remains fully functional
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET | 
    Where-Object { $_.status -eq 'normal' } | 
    Select-Object id, name, customProperties |
    Export-Csv devices.csv  # ✅ Works perfectly!
```

**Tip:** For frequently used endpoints, create a wrapper function with custom formatting:
```powershell
function Get-MyCustomResource {
    Invoke-LMAPIRequest -ResourcePath "/custom/endpoint" -Method GET |
        Format-Table id, name, status, created -AutoSize
}
```

## Design Patterns

### Pattern 1: Testing New API Features
```powershell
# Test a beta endpoint before requesting a dedicated cmdlet
$betaData = @{
    feature = "new-capability"
    enabled = $true
}
Invoke-LMAPIRequest -ResourcePath "/beta/features" -Method POST -Data $betaData -Version 4
```

### Pattern 2: Bulk Operations
```powershell
# Bulk update multiple resources
$deviceIds = 1..100
foreach ($id in $deviceIds) {
    $updates = @{ description = "Bulk updated $(Get-Date)" }
    Invoke-LMAPIRequest -ResourcePath "/device/devices/$id" -Method PATCH -Data $updates
    Start-Sleep -Milliseconds 100  # Rate limiting
}
```

### Pattern 3: Custom Workflows
```powershell
# Complex workflow combining multiple API calls
function Deploy-CustomConfiguration {
    param($ConfigName, $Targets)
    
    # Step 1: Create configuration
    $config = @{ name = $ConfigName; type = "custom" }
    $created = Invoke-LMAPIRequest -ResourcePath "/configs" -Method POST -Data $config
    
    # Step 2: Apply to targets
    foreach ($target in $Targets) {
        $assignment = @{ configId = $created.id; targetId = $target }
        Invoke-LMAPIRequest -ResourcePath "/configs/assignments" -Method POST -Data $assignment
    }
    
    # Step 3: Verify deployment
    $status = Invoke-LMAPIRequest -ResourcePath "/configs/$($created.id)/status" -Method GET
    return $status
}
```

### Pattern 4: Error Handling
```powershell
try {
    $result = Invoke-LMAPIRequest `
        -ResourcePath "/risky/endpoint" `
        -Method POST `
        -Data $data `
        -ErrorAction Stop
    
    Write-Host "Success: $($result.id)"
}
catch {
    Write-Error "API request failed: $($_.Exception.Message)"
    # Fallback logic here
}
```

## Best Practices

### 1. Use Dedicated Cmdlets When Available
```powershell
# ❌ Don't do this
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET

# ✅ Do this instead
Get-LMDevice
```

### 2. Validate Input Before Sending
```powershell
function New-CustomResource {
    param($Name, $Type)
    
    # Validate locally first
    if ([string]::IsNullOrWhiteSpace($Name)) {
        throw "Name cannot be empty"
    }
    
    $data = @{ name = $Name; type = $Type }
    Invoke-LMAPIRequest -ResourcePath "/custom/resources" -Method POST -Data $data
}
```

### 3. Use -WhatIf for Testing
```powershell
# Test without making actual changes
Invoke-LMAPIRequest `
    -ResourcePath "/device/devices/123" `
    -Method DELETE `
    -WhatIf
```

### 4. Leverage Debug Output
```powershell
# Enable debug to see full request details
Invoke-LMAPIRequest `
    -ResourcePath "/endpoint" `
    -Method POST `
    -Data $data `
    -Debug
```

### 5. Handle Pagination Properly
```powershell
# For large datasets, use pagination
$size = 1000  # Max batch size
$offset = 0
do {
    $batch = Invoke-LMAPIRequest `
        -ResourcePath "/large/dataset" `
        -Method GET `
        -QueryParams @{ size = $size; offset = $offset }
    
    Process-Batch $batch.items
    $offset += $size
} while ($batch.items.Count -eq $size)
```

## Integration with Module Features

### Authentication
Automatically uses the current session from `Connect-LMAccount`:
```powershell
Connect-LMAccount -AccessId $id -AccessKey $key -AccountName "company"
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET
# No need to handle auth manually!
```

### Retry Logic
Built-in exponential backoff for transient failures:
```powershell
# Automatically retries on 429, 502, 503, 504
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET -MaxRetries 5

# Disable retries for time-sensitive operations
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET -NoRetry
```

### Debug Information
Integrates with module debug utilities:
```powershell
# Shows full request details including headers, URL, payload
$DebugPreference = "Continue"
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method POST -Data $data
```

## Common Use Cases

### 1. Accessing New API Endpoints
```powershell
# LogicMonitor releases a new API endpoint
# Use Invoke-LMAPIRequest until a dedicated cmdlet is available
Invoke-LMAPIRequest -ResourcePath "/new/feature" -Method GET
```

### 2. Custom Integrations
```powershell
# Build custom integrations with external systems
$webhookData = @{
    url = "https://external-system.com/webhook"
    events = @("alert.created", "alert.cleared")
}
Invoke-LMAPIRequest -ResourcePath "/integrations/webhooks" -Method POST -Data $webhookData
```

### 3. Prototyping
```powershell
# Prototype new functionality before requesting cmdlet additions
# Test different approaches quickly
$approaches = @(
    @{ method = "approach1"; params = @{} },
    @{ method = "approach2"; params = @{} }
)

foreach ($approach in $approaches) {
    $result = Invoke-LMAPIRequest `
        -ResourcePath "/test/endpoint" `
        -Method POST `
        -Data $approach
    
    Measure-Performance $result
}
```

### 4. Advanced Filtering
```powershell
# Complex filters not yet supported by dedicated cmdlets
$complexFilter = 'name~"prod-*" && status:"active" && customProperties.environment:"production"'
Invoke-LMAPIRequest `
    -ResourcePath "/device/devices" `
    -Method GET `
    -QueryParams @{ filter = $complexFilter; size = 1000 }
```

## Troubleshooting

### Issue: "Invalid json body" or "Cannot deserialize" Errors

This usually means your data structure doesn't match the API's expected format.

**Common Issue: customProperties Format**
```powershell
# ❌ Wrong - This will fail
$data = @{
    name = "device1"
    customProperties = @{ environment = "prod" }  # Simple hashtable
}

# ✅ Correct - Array of name/value objects
$data = @{
    name = "device1"
    customProperties = @(
        @{ name = "environment"; value = "prod" }
    )
}
```

**Solution:** Check the LogicMonitor API documentation or look at how dedicated cmdlets format the data:
```powershell
# Compare with working cmdlet
New-LMDevice -Name "test" -DisplayName "test" -PreferredCollectorId 1 -Properties @{test="value"} -Debug

# Look at the "Request Payload" in debug output to see the correct format
```

### Issue: Authentication Errors
```powershell
# Verify you're connected
if (-not $Script:LMAuth.Valid) {
    Connect-LMAccount -AccessId $id -AccessKey $key -AccountName "company"
}
```

### Issue: Rate Limiting
```powershell
# Increase retry attempts or add delays
Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET -MaxRetries 10

# Or add manual delays in loops
foreach ($item in $items) {
    Invoke-LMAPIRequest -ResourcePath "/endpoint/$item" -Method GET
    Start-Sleep -Milliseconds 500
}
```

### Issue: Unexpected Response Format
```powershell
# Use -Debug to see raw response
$result = Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET -Debug

# Or capture as hashtable for inspection
$result = Invoke-LMAPIRequest -ResourcePath "/endpoint" -Method GET -AsHashtable
$result.Keys | ForEach-Object { Write-Host "$_: $($result[$_])" }
```

## Contributing

If you find yourself frequently using `Invoke-LMAPIRequest` for a specific endpoint, consider:
1. Opening a GitHub issue requesting a dedicated cmdlet
2. Contributing a PR with the new cmdlet implementation
3. Sharing your use case to help prioritize development

## Related Cmdlets

- `Connect-LMAccount` - Establish authentication
- `Get-LMDevice`, `New-LMDevice`, etc. - Dedicated resource cmdlets
- `Build-LMFilter` - Interactive filter builder
- `Invoke-LMRestMethod` - Internal REST method wrapper (not for direct use)

## Summary

`Invoke-LMAPIRequest` bridges the gap between the module's current capabilities and the full LogicMonitor API surface area. It empowers advanced users to:
- Access any API endpoint immediately
- Prototype new functionality
- Build custom integrations
- Test beta features

While maintaining the benefits of:
- Centralized authentication
- Robust error handling
- Automatic retries
- Consistent debugging
- Module best practices

Use it when you need flexibility, but prefer dedicated cmdlets for routine operations.

