---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAppliesToFunction

## SYNOPSIS
Creates a new LogicMonitor Applies To function.

## SYNTAX

```
New-LMAppliesToFunction [-Name] <String> [[-Description] <String>] [-AppliesTo] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAppliesToFunction function creates a new Applies To function that can be used in LogicMonitor for targeting resources.

## EXAMPLES

### EXAMPLE 1
```
#Create a new Applies To function
New-LMAppliesToFunction -Name "WindowsServers" -AppliesTo "isWindows() && hasCategory('server')" -Description "Targets Windows servers"
```

## PARAMETERS

### -Name
The name of the function.
This parameter is mandatory.

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

### -Description
A description of the function's purpose.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppliesTo
The function code that defines the targeting logic.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

### Returns the created function object.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
