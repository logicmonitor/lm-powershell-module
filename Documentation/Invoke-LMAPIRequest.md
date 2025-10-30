---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMAPIRequest

## SYNOPSIS
Executes a custom LogicMonitor API request with full control over endpoint and payload.

## SYNTAX

### Data (Default)
```
Invoke-LMAPIRequest -ResourcePath <String> -Method <String> [-QueryParams <Hashtable>] [-Data <Hashtable>]
 [-Version <Int32>] [-ContentType <String>] [-MaxRetries <Int32>] [-NoRetry] [-OutFile <String>]
 [-TypeName <String>] [-AsHashtable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### RawBody
```
Invoke-LMAPIRequest -ResourcePath <String> -Method <String> [-QueryParams <Hashtable>] [-RawBody <String>]
 [-Version <Int32>] [-ContentType <String>] [-MaxRetries <Int32>] [-NoRetry] [-OutFile <String>]
 [-TypeName <String>] [-AsHashtable] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMAPIRequest function provides advanced users with direct access to the LogicMonitor API
while leveraging the module's authentication, retry logic, debug utilities, and error handling.
This is useful for accessing API endpoints that don't yet have dedicated cmdlets in the module.

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method GET
```

Get a custom resource not yet supported by a dedicated cmdlet.

### EXAMPLE 2
```powershell
$data = @{
    name = "My Integration"
    type = "slack"
    url = "https://hooks.slack.com/services/..."
}
Invoke-LMAPIRequest -ResourcePath "/setting/integrations" -Method POST -Data $data
```

Create a resource with custom payload.

### EXAMPLE 3
```powershell
$updates = @{
    description = "Updated description"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices/123" -Method PATCH -Data $updates
```

Update a resource with PATCH.

### EXAMPLE 4
```powershell
Invoke-LMAPIRequest -ResourcePath "/setting/integrations/456" -Method DELETE
```

Delete a resource.

### EXAMPLE 5
```powershell
$queryParams = @{
    size = 500
    filter = 'status:"active"'
    fields = "id,name,status"
}
Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams $queryParams -Version 3
```

Get with query parameters and custom version.

### EXAMPLE 6
```powershell
$rawJson = '{"name":"test","customField":null}'
Invoke-LMAPIRequest -ResourcePath "/custom/endpoint" -Method POST -RawBody $rawJson
```

Use raw body for special formatting requirements.

### EXAMPLE 7
```powershell
Invoke-LMAPIRequest -ResourcePath "/report/reports/123/download" -Method GET -OutFile "C:\Reports\report.pdf"
```

Download a report to file.

### EXAMPLE 8
```powershell
$offset = 0
$size = 1000
$allResults = @()
do {
    $response = Invoke-LMAPIRequest -ResourcePath "/device/devices" -Method GET -QueryParams @{ size = $size; offset = $offset }
    $allResults += $response.items
    $offset += $size
} while ($allResults.Count -lt $response.total)
```

Get paginated results manually.

## PARAMETERS

### -ResourcePath
The API resource path (e.g., "/device/devices", "/setting/integrations/123").
Do not include the base URL or query parameters here.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The HTTP method to use. Valid values: GET, POST, PATCH, PUT, DELETE.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: GET, POST, PATCH, PUT, DELETE

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -QueryParams
Optional hashtable of query parameters to append to the request URL.
Example: @{ size = 100; offset = 0; filter = 'name:"test"' }

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Data
Optional hashtable containing the request body data. Will be automatically converted to JSON.
Use this for POST, PATCH, and PUT requests.

```yaml
Type: Hashtable
Parameter Sets: Data
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RawBody
Optional raw string body to send with the request. Use this instead of -Data when you need
complete control over the request body format. Mutually exclusive with -Data.

```yaml
Type: String
Parameter Sets: RawBody
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
The X-Version header value for the API request. Defaults to 3.
Some newer API endpoints may require different version numbers.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -ContentType
The Content-Type header for the request. Defaults to "application/json".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: application/json
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxRetries
Maximum number of retry attempts for transient errors. Defaults to 3.
Set to 0 to disable retries.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 3
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoRetry
Switch to completely disable retry logic and fail immediately on any error.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Path to save the response content to a file. Useful for downloading reports or exports.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName
Optional type name to add to the returned objects (e.g., "LogicMonitor.CustomResource").
This enables proper formatting if you have custom format definitions.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsHashtable
Switch to return the response as a hashtable instead of a PSCustomObject.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
You cannot pipe objects to this command.

## OUTPUTS

### System.Object
Returns the API response as a PSCustomObject by default, or as specified by -AsHashtable.

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

[Module Documentation](https://logicmonitor.github.io/lm-powershell-module-docs/)

