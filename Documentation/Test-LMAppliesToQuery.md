---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Test-LMAppliesToQuery

## SYNOPSIS
Tests the applies to query against the LogicMonitor API.

## SYNTAX

```
Test-LMAppliesToQuery [-Query] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Test-LMAppliesToQuery function is used to test the applies to query against the LogicMonitor API.

## EXAMPLES

### EXAMPLE 1
```
Test-LMAppliesToQuery -Query "system.hostname == 'server01'"
```

This example tests the applies to query "system.hostname == 'server01'" against the LogicMonitor API and returns a list of matching devices.

## PARAMETERS

### -Query
The applies to query to be tested.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

## OUTPUTS

## NOTES

## RELATED LINKS
