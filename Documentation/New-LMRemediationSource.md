---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMRemediationSource

## SYNOPSIS
Creates a new LogicMonitor remediation source.

## SYNTAX

```
New-LMRemediationSource [-RemediationSource] <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-LMRemediationSource function creates a new remediation source in LogicMonitor using
a provided remediation source configuration object.

## EXAMPLES

### EXAMPLE 1
```
# Create a new remediation source
$config = @{
    name = "MyRemediationSource"
    # Additional configuration properties
}
New-LMRemediationSource -RemediationSource $config
```

## PARAMETERS

### -RemediationSource
A PSCustomObject containing the remediation source configuration.
Must follow the schema model
defined in LogicMonitor's API documentation.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.RemediationSource object.
## NOTES
You must run Connect-LMAccount before running this command.
For remediation source schema details, see the LogicMonitor API documentation.

## RELATED LINKS
