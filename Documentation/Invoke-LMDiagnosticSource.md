---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMDiagnosticSource

## SYNOPSIS
Triggers a diagnostic source execution for a host.

## SYNTAX

### Id-diagnosticId (Default)
```
Invoke-LMDiagnosticSource -Id <Int32> -DiagnosticId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-diagnosticName
```
Invoke-LMDiagnosticSource -Id <Int32> -DiagnosticName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-diagnosticName
```
Invoke-LMDiagnosticSource -Name <String> -DiagnosticName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-diagnosticId
```
Invoke-LMDiagnosticSource -Name <String> -DiagnosticId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName-diagnosticName
```
Invoke-LMDiagnosticSource -DisplayName <String> -DiagnosticName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName-diagnosticId
```
Invoke-LMDiagnosticSource -DisplayName <String> -DiagnosticId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMDiagnosticSource function manually triggers a diagnostic source execution for a
LogicMonitor host.
The host can be identified by ID, name, or display name, and the diagnostic
source can be identified by ID or name.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMDiagnosticSource -Id 123 -DiagnosticId 456
```

Triggers diagnostic source ID 456 on host ID 123.

### EXAMPLE 2
```
Invoke-LMDiagnosticSource -HostName "server01" -DiagnosticName "Disk Troubleshooter" -AlertId "A123456"
```

Looks up host and diagnostic source by name, then triggers a diagnostic execution associated with alert A123456.

## PARAMETERS

### -Id
The host ID to run the diagnostic source against.
Alias: HostId.

```yaml
Type: Int32
Parameter Sets: Id-diagnosticId, Id-diagnosticName
Aliases: HostId, DeviceId

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The host name to run the diagnostic source against.
Alias: HostName.

```yaml
Type: String
Parameter Sets: Name-diagnosticName, Name-diagnosticId
Aliases: HostName, DeviceName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
The host display name to run the diagnostic source against.

```yaml
Type: String
Parameter Sets: DisplayName-diagnosticName, DisplayName-diagnosticId
Aliases: HostDisplayName, DeviceDisplayName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiagnosticId
The diagnostic source ID to execute.

```yaml
Type: Int32
Parameter Sets: Id-diagnosticId, Name-diagnosticId, DisplayName-diagnosticId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DiagnosticName
The diagnostic source name to execute.

```yaml
Type: String
Parameter Sets: Id-diagnosticName, Name-diagnosticName, DisplayName-diagnosticName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertId
Optional alert ID associated with this diagnostic execution.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.DiagnosticSourceExecution object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
