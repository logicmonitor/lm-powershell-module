---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMCollectorConfig

## SYNOPSIS
Updates a LogicMonitor collector's configuration settings.

## SYNTAX

### Id-SnippetConf
```
Set-LMCollectorConfig [-Id <Int32>] [-SnmpThreadPool <Int32>] [-SnmpPduTimeout <Int32>]
 [-ScriptThreadPool <Int32>] [-ScriptTimeout <Int32>] [-BatchScriptThreadPool <Int32>]
 [-BatchScriptTimeout <Int32>] [-PowerShellSPSEProcessCountMin <Int32>]
 [-PowerShellSPSEProcessCountMax <Int32>] [-NetflowEnable <Boolean>] [-NbarEnable <Boolean>]
 [-NetflowPorts <String[]>] [-SflowPorts <String[]>] [-LMLogsSyslogEnable <Boolean>]
 [-LMLogsSyslogHostnameFormat <String>] [-LMLogsSyslogPropertyName <String>] [-WaitForRestart]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-Conf
```
Set-LMCollectorConfig [-Id <Int32>] [-CollectorSize <String>] [-CollectorConf <String>] [-SbproxyConf <String>]
 [-WatchdogConf <String>] [-WebsiteConf <String>] [-WrapperConf <String>] [-WaitForRestart]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-SnippetConf
```
Set-LMCollectorConfig [-Name <String>] [-SnmpThreadPool <Int32>] [-SnmpPduTimeout <Int32>]
 [-ScriptThreadPool <Int32>] [-ScriptTimeout <Int32>] [-BatchScriptThreadPool <Int32>]
 [-BatchScriptTimeout <Int32>] [-PowerShellSPSEProcessCountMin <Int32>]
 [-PowerShellSPSEProcessCountMax <Int32>] [-NetflowEnable <Boolean>] [-NbarEnable <Boolean>]
 [-NetflowPorts <String[]>] [-SflowPorts <String[]>] [-LMLogsSyslogEnable <Boolean>]
 [-LMLogsSyslogHostnameFormat <String>] [-LMLogsSyslogPropertyName <String>] [-WaitForRestart]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-Conf
```
Set-LMCollectorConfig [-Name <String>] [-CollectorSize <String>] [-CollectorConf <String>]
 [-SbproxyConf <String>] [-WatchdogConf <String>] [-WebsiteConf <String>] [-WrapperConf <String>]
 [-WaitForRestart] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMCollectorConfig function modifies detailed configuration settings for a collector, including SNMP settings, script settings, and various other parameters.
This operation will restart the collector.

## EXAMPLES

### EXAMPLE 1
```
Set-LMCollectorConfig -Id 123 -CollectorSize "medium" -WaitForRestart
Updates the collector size and waits for the restart to complete.
```

## PARAMETERS

### -Id
Specifies the ID of the collector to configure.

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Id-Conf
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name of the collector to configure.

```yaml
Type: String
Parameter Sets: Name-SnippetConf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorSize
Specifies the size of the collector.
Valid values are "nano", "small", "medium", "large", "extra_large", "double_extra_large".

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorConf
Specifies the collector configuration file content.

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SbproxyConf
Specifies the sbproxy configuration file content.

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WatchdogConf
Specifies the watchdog configuration file content.

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteConf
Specifies the website configuration file content.

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WrapperConf
Specifies the wrapper configuration file content.

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SnmpThreadPool
{{ Fill SnmpThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SnmpPduTimeout
{{ Fill SnmpPduTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptThreadPool
{{ Fill ScriptThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptTimeout
{{ Fill ScriptTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchScriptThreadPool
{{ Fill BatchScriptThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchScriptTimeout
{{ Fill BatchScriptTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PowerShellSPSEProcessCountMin
{{ Fill PowerShellSPSEProcessCountMin Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PowerShellSPSEProcessCountMax
{{ Fill PowerShellSPSEProcessCountMax Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowEnable
{{ Fill NetflowEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NbarEnable
{{ Fill NbarEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowPorts
{{ Fill NetflowPorts Description }}

```yaml
Type: String[]
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SflowPorts
{{ Fill SflowPorts Description }}

```yaml
Type: String[]
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMLogsSyslogEnable
{{ Fill LMLogsSyslogEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMLogsSyslogHostnameFormat
{{ Fill LMLogsSyslogHostnameFormat Description }}

```yaml
Type: String
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMLogsSyslogPropertyName
{{ Fill LMLogsSyslogPropertyName Description }}

```yaml
Type: String
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitForRestart
Indicates whether to wait for the collector restart to complete.

\[Additional parameters for snippet configuration omitted for brevity\]

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
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

### You can pipe objects containing Id properties to this function.
## OUTPUTS

### Returns a string indicating the status of the configuration update and restart operation.
## NOTES
This function requires a valid LogicMonitor API authentication and will restart the collector.

## RELATED LINKS
