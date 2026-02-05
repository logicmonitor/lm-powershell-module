---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMPortalVersion

## SYNOPSIS
Retrieves the LogicMonitor portal version from API response headers.

## SYNTAX

```
Get-LMPortalVersion [-Force] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMPortalVersion function makes a lightweight API call to retrieve the portal version
from the x-server-version response header.
The version is cached in $Script:LMAuth.Version
for the duration of the session to avoid repeated API calls.

## EXAMPLES

### EXAMPLE 1
```
$version = Get-LMPortalVersion
Write-Host "Portal version: $($version.RawVersion)"
```

### EXAMPLE 2
```
$version = Get-LMPortalVersion -Force
if ($version.Major -ge 231) { Write-Host "Feature supported" }
```

## PARAMETERS

### -Force
Forces a fresh API call to retrieve the version, bypassing the cached value.

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

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### Returns a PSCustomObject with RawVersion (string), Major (int), and Minor (int) properties.
## NOTES
This is a private function used internally by the module.

## RELATED LINKS
