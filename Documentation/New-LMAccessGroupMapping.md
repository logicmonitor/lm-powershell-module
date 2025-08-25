---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAccessGroupMapping

## SYNOPSIS
Creates a new LogicMonitor access group mapping.

## SYNTAX

```
New-LMAccessGroupMapping [-AccessGroupIds] <String[]> [-LogicModuleType] <String> [-LogicModuleId] <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAccessGroupMapping function creates a mapping between an access group and a logic module in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
#Create a new access group mapping
New-LMAccessGroupMapping -AccessGroupIds "12345" -LogicModuleType "DATASOURCE" -LogicModuleId "67890"
```

## PARAMETERS

### -AccessGroupIds
The IDs of the access groups to map.
This parameter is mandatory.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicModuleType
The type of logic module.
Valid values are "DATASOURCE", "EVENTSOURCE", "BATCHJOB", "JOBMONITOR", "LOGSOURCE", "TOPOLOGYSOURCE", "PROPERTYSOURCE", "APPLIESTO_FUNCTION", "SNMP_SYSOID_MAP".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogicModuleId
The ID of the logic module to map.
This parameter is mandatory.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: 0
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

### Returns mapping details object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
