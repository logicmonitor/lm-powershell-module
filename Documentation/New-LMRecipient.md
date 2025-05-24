---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMRecipient

## SYNOPSIS
Creates a new LogicMonitor recipient object.

## SYNTAX

```
New-LMRecipient [-Type] <String> [-Addr] <String> [[-Method] <String>] [[-Contact] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMRecipient function creates a new LogicMonitor recipient object that can be used with recipient groups.
The recipient can be an admin user, arbitrary email, or another recipient group.

## EXAMPLES

### EXAMPLE 1
```
New-LMRecipient -Type ADMIN -Addr "admin@company.com" -Method "email"
Creates a new admin recipient that will receive email notifications.
```

### EXAMPLE 2
```
New-LMRecipient -Type GROUP -Addr "EmergencyContacts"
Creates a new recipient that references an existing recipient group.
```

## PARAMETERS

### -Type
The type of recipient.
Must be one of: ADMIN, ARBITRARY, or GROUP.

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

### -Addr
The address of the recipient.
For ADMIN/ARBITRARY this is an email address, for GROUP this is the group name.

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

### -Method
The notification method for ADMIN recipients.
Not used for GROUP type.
Possible values: email, sms, voice, smsemail or the name of an existing integration

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Contact
Optional contact information for the recipient.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

### Returns a hashtable containing the recipient configuration.
## NOTES

## RELATED LINKS
