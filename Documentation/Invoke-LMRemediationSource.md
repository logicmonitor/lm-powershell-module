---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMRemediationSource

## SYNOPSIS
Triggers a remediation source execution for a host.

## SYNTAX

### Id-remediationId (Default)
```
Invoke-LMRemediationSource -Id <Int32> -RemediationId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-remediationName
```
Invoke-LMRemediationSource -Id <Int32> -RemediationName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-remediationName
```
Invoke-LMRemediationSource -Name <String> -RemediationName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-remediationId
```
Invoke-LMRemediationSource -Name <String> -RemediationId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName-remediationName
```
Invoke-LMRemediationSource -DisplayName <String> -RemediationName <String> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName-remediationId
```
Invoke-LMRemediationSource -DisplayName <String> -RemediationId <Int32> [-AlertId <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMRemediationSource function manually triggers a remediation source execution for a
LogicMonitor host.
The host can be identified by ID, name, or display name, and the remediation
source can be identified by ID or name.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMRemediationSource -Id 123 -RemediationId 456
```

Triggers remediation source ID 456 on host ID 123.

### EXAMPLE 2
```
Invoke-LMRemediationSource -HostName "server01" -RemediationName "Restart Agent" -AlertId "A123456"
```

Looks up host and remediation source by name, then triggers a remediation execution associated with alert A123456.

## PARAMETERS

### -Id
The host ID to run the remediation source against.
Alias: HostId.

```yaml
Type: Int32
Parameter Sets: Id-remediationId, Id-remediationName
Aliases: HostId, DeviceId

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The host name to run the remediation source against.
Alias: HostName.

```yaml
Type: String
Parameter Sets: Name-remediationName, Name-remediationId
Aliases: HostName, DeviceName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
The host display name to run the remediation source against.

```yaml
Type: String
Parameter Sets: DisplayName-remediationName, DisplayName-remediationId
Aliases: HostDisplayName, DeviceDisplayName

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemediationId
The remediation source ID to execute.

```yaml
Type: Int32
Parameter Sets: Id-remediationId, Name-remediationId, DisplayName-remediationId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemediationName
The remediation source name to execute.

```yaml
Type: String
Parameter Sets: Id-remediationName, Name-remediationName, DisplayName-remediationName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AlertId
Optional alert ID associated with this remediation execution.

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

### Returns LogicMonitor.RemediationSourceExecution object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
