---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: New-LMRecipientGroup
---

# New-LMRecipientGroup

## SYNOPSIS

Creates a new LogicMonitor recipient group.

## SYNTAX

### __AllParameterSets

```
New-LMRecipientGroup [-Name] <string> [[-Description] <string>] [-Recipients] <array> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

The New-LMRecipientGroup function creates a new LogicMonitor recipient group with the specified parameters.

## EXAMPLES

### EXAMPLE 1

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

## PARAMETERS

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- cf
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Description

The description of the recipient group.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 1
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the recipient group.
This parameter is mandatory.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Recipients

A object containing the recipients for the recipient group.
The object must contain a "method", "type" and "addr" key.

```yaml
Type: System.Array
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 2
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -WhatIf

Runs the command in a mode that only reports what would happen without performing the actions.

```yaml
Type: System.Management.Automation.SwitchParameter
DefaultValue: ''
SupportsWildcards: false
Aliases:
- wi
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns LogicMonitor.RecipientGroup object.

## NOTES

This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS

