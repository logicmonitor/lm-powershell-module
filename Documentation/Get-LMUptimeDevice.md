---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMUptimeDevice

## SYNOPSIS
Retrieves LogicMonitor Uptime devices from the v3 device endpoint.

## SYNTAX

### All (Default)
```
Get-LMUptimeDevice [-Type <String>] [-IsInternal <Boolean>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMUptimeDevice [-Id <Int32>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMUptimeDevice [-Name <String>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMUptimeDevice [-Type <String>] [-Filter <Object>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FilterWizard
```
Get-LMUptimeDevice [-Type <String>] [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMUptimeDevice cmdlet returns Uptime monitors (web or ping) that are backed by the
LogicMonitor v3 /device/devices endpoint.
It supports lookup by ID or name, optional filtering
by internal/external flag, custom filters, and the interactive filter wizard.
The Type parameter
is optional and filters by webcheck or pingcheck uptime devices.
If not specified, both types
are returned.

## EXAMPLES

### EXAMPLE 1
```
Get-LMUptimeDevice
```

Retrieves all Uptime devices (both webcheck and pingcheck) across the account.

### EXAMPLE 2
```
Get-LMUptimeDevice -Type uptimewebcheck
```

Retrieves all web Uptime devices across the account.

### EXAMPLE 3
```
Get-LMUptimeDevice -Type uptimewebcheck -IsInternal $true
```

Retrieves internal web Uptime devices only.

### EXAMPLE 4
```
Get-LMUptimeDevice -Name "web-int-01"
```

Retrieves a specific Uptime device by name.

### EXAMPLE 5
```
Get-LMUptimeDevice -Id 123
```

Retrieves a specific Uptime device by ID.

## PARAMETERS

### -Id
Specifies the identifier of the Uptime device to retrieve.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the Uptime device to retrieve.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the Uptime monitor type to retrieve.
Valid values are uptimewebcheck and uptimepingcheck.
If not specified, both types are returned.

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

### -IsInternal
Filters results by internal (true) or external (false) monitors.

```yaml
Type: Boolean
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Provides a filter object for advanced queries.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterWizard
Launches the interactive filter wizard and applies the chosen filter.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Controls the number of results returned per request.
Must be between 1 and 1000.
Default 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### None. You cannot pipe objects to this cmdlet.
## OUTPUTS

### LogicMonitor.LMUptimeDevice
## NOTES
You must run Connect-LMAccount before invoking this cmdlet.
Responses are tagged with the
LogicMonitor.LMUptimeDevice type information.

## RELATED LINKS

[New-LMUptimeDevice]()

[Set-LMUptimeDevice]()

[Remove-LMUptimeDevice]()

