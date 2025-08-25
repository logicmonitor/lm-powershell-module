---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMRecipientGroup

## SYNOPSIS
Creates a new LogicMonitor recipient group.

## SYNTAX

```
New-LMRecipientGroup [-Name] <String> [[-Description] <String>] [-Recipients] <Array>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The New-LMRecipientGroup function creates a new LogicMonitor recipient group with the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
$recipients = @(
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'email'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'sms'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'voice'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method 'smsemail'
    New-LMRecipient -Type 'ADMIN' -Addr 'user@domain.com' -Method '<name_of_existing_integration>'
    New-LMRecipient -Type 'ARBITRARY' -Addr 'someone@other.com' -Method 'email'
    New-LMRecipient -Type 'GROUP' -Addr 'Helpdesk'
)
New-LMRecipientGroup -Name "MyRecipientGroup" -Description "This is a test recipient group" -Recipients $recipients
This example creates a new LogicMonitor recipient group named "MyRecipientGroup" with a description and recipients built using the New-LMRecipient function.
```

## PARAMETERS

### -Name
The name of the recipient group.
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
The description of the recipient group.

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

### -Recipients
A object containing the recipients for the recipient group.
The object must contain a "method", "type" and "addr" key.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
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

### Returns LogicMonitor.RecipientGroup object.
## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
