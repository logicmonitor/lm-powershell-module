---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Invoke-LMAPIRequest
---

# Invoke-LMAPIRequest

## SYNOPSIS

Executes a custom LogicMonitor API request with full control over endpoint and payload.

## SYNTAX

### Data (Default)

```
Invoke-LMAPIRequest -ResourcePath <string> -Method <string> [-QueryParams <hashtable>]
 [-Data <hashtable>] [-Version <int>] [-ContentType <string>] [-MaxRetries <int>] [-NoRetry]
 [-OutFile <string>] [-TypeName <string>] [-AsHashtable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RawBody

```
Invoke-LMAPIRequest -ResourcePath <string> -Method <string> [-QueryParams <hashtable>]
 [-RawBody <string>] [-Version <int>] [-ContentType <string>] [-MaxRetries <int>] [-NoRetry]
 [-OutFile <string>] [-TypeName <string>] [-AsHashtable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The Invoke-LMAPIRequest function provides advanced users with direct access to the LogicMonitor API
while leveraging the module's authentication, retry logic, debug utilities, and error handling.
This is useful for accessing API endpoints that don't yet have dedicated cmdlets in the module.

## EXAMPLES

### EXAMPLE 1

# Get a custom resource not yet supported by a dedicated cmdlet
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method GET

### EXAMPLE 2

# Create a resource with custom payload
$data = @{
    name = "My Integration"
    type = "slack"
    url = "https://hooks.slack.com/services/..."
}
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method POST -Data $data

### EXAMPLE 3

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

### EXAMPLE 4

# Update a resource with PATCH
$updates = @{
    description = "Updated description"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices/123" -Method PATCH -Data $updates

### EXAMPLE 5

# Delete a resource
Invoke-LMAPIRequest -ResourcePath "/setting/integrations/456" -Method DELETE

### EXAMPLE 6

# Get with query parameters and custom version
$queryParams = @{
    size = 500
    filter = 'status:"active"'
    fields = "id,name,status"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams $queryParams -Version 3

### EXAMPLE 7

# Use raw body for special formatting requirements
$rawJson = '{"name":"test","customField":null}'
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint" -Method POST -RawBody $rawJson

### EXAMPLE 8

# Download a report to file
Invoke-LMAPIRequest -ResourcePath "/report/reports/123/download" -Method GET -OutFile "C:\Reports\report.pdf"

### EXAMPLE 9

# Format output as table
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET | Format-Table id, name, displayName, status

# Use existing format definition
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -TypeName "LogicMonitor.Device"

### EXAMPLE 10

# Get paginated results manually
$offset = 0
$size = 1000
$allResults = @()
do {
    $response = Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams @{ size = $size; offset = $offset }
    $allResults += $response.items
    $offset += $size
} while ($allResults.Count -lt $response.total)

## PARAMETERS

### -AsHashtable

Switch to return the response as a hashtable instead of a PSCustomObject.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ContentType

The Content-Type header for the request.
Defaults to "application/json".

```yaml
Type: System.String
DefaultValue: application/json
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Data

Optional hashtable containing the request body data.
Will be automatically converted to JSON.
Use this for POST, PATCH, and PUT requests.

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Data
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -MaxRetries

Maximum number of retry attempts for transient errors.
Defaults to 3.
Set to 0 to disable retries.

```yaml
Type: System.Int32
DefaultValue: 3
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Method

The HTTP method to use.
Valid values: GET, POST, PATCH, PUT, DELETE.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -NoRetry

Switch to completely disable retry logic and fail immediately on any error.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OutFile

Path to save the response content to a file.
Useful for downloading reports or exports.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -QueryParams

Optional hashtable of query parameters to append to the request URL.
Example: @{ size = 100; offset = 0; filter = 'name:"test"' }

```yaml
Type: System.Collections.Hashtable
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -RawBody

Optional raw string body to send with the request.
Use this instead of -Data when you need
complete control over the request body format.
Mutually exclusive with -Data.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: RawBody
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ResourcePath

The API resource path (e.g., "/device/devices", "/setting/integrations/123").
Do not include the base URL or query parameters here.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -TypeName

Optional type name to add to the returned objects (e.g., "LogicMonitor.CustomResource").
This enables proper formatting if you have custom format definitions.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Version

The X-Version header value for the API request.
Defaults to 3.
Some newer API endpoints may require different version numbers.

```yaml
Type: System.Int32
DefaultValue: 3
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns the API response as a PSCustomObject by default

### System.Collections.Hashtable

## NOTES

You must run Connect-LMAccount before running this command.

This cmdlet is designed for advanced users who need to:
- Access API endpoints not yet covered by dedicated cmdlets
- Test new API features or beta endpoints
- Implement custom workflows requiring direct API access
- Prototype new functionality before requesting cmdlet additions

For standard operations, use the dedicated cmdlets (Get-LMDevice, New-LMDevice, etc.) as they
provide better parameter validation, documentation, and user experience.

## RELATED LINKS

