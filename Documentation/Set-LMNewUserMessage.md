---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMNewUserMessage

## SYNOPSIS
Updates the new user message template in LogicMonitor.

## SYNTAX

```
Set-LMNewUserMessage [-MessageBody] <String> [-MessageSubject] <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Set-LMNewUserMessage function modifies the message template that is sent to new users in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMNewUserMessage -MessageBody "Welcome to our monitoring system" -MessageSubject "Welcome to LogicMonitor"
Updates the new user message template with the specified subject and body.
```

## PARAMETERS

### -MessageBody
Specifies the body content of the message template.

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

### -MessageSubject
Specifies the subject line of the message template.

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

### None.
## OUTPUTS

### Returns the response from the API indicating the success of the update.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
