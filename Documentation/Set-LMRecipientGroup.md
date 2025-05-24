---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMRecipientGroup

## SYNOPSIS
Update a LogicMonitor recipient group.

## SYNTAX

### Id (Default)
```
Set-LMRecipientGroup -Id <String> [-NewName <String>] [-Description <String>] [-Recipients <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Set-LMRecipientGroup -Name <String> [-NewName <String>] [-Description <String>] [-Recipients <PSObject>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMRecipientGroup function updates a LogicMonitor recipient group with the specified parameters.

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
Set-LMRecipientGroup -Id "1234567890" -NewName "MyRecipientGroupUpdated" -Description "This is a test recipient group updated" -Recipients $recipients
This example updates a LogicMonitor recipient group named "MyRecipientGroupUpdated" with a description and recipients built using the New-LMRecipient function.
```

## PARAMETERS

### -Id
The id of the recipient group.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
The name of the recipient group to lookup instead of the id.
This parameter is optional.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
The new name of the recipient group.
This parameter is optional.

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

### -Description
The description of the recipient group.
This parameter is optional.

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

### -Recipients
A object containing the recipients for the recipient group.

```yaml
Type: PSObject
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

### Returns LogicMonitor.RecipientGroup object.
## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
