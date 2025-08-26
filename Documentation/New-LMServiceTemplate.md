---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMServiceTemplate

## SYNOPSIS
Creates a new LogicMonitor Service template.

## SYNTAX

```
New-LMServiceTemplate [-Name] <String> [[-Description] <String>] [[-Cardinality] <Array>]
 [[-PropertySelector] <Array>] [[-Properties] <Array>] [[-ServiceNamingPattern] <Array>]
 [[-CreateGroup] <Boolean>] [[-GroupNamingPattern] <Array>] [[-DefaultCriticality] <String>]
 [[-MembershipEvaluationInterval] <String>] [[-FilterType] <String>] [[-ResourceGroupRecords] <Array>]
 [[-Criticality] <Array>] [[-StaticGroup] <Array>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMServiceTemplate function creates a new LogicMonitor Service template with the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
New-LMServiceTemplate -Name "Application Services by Site" -Description "Default LM service template for application services"
```

This example creates a new LogicMonitor Service template with basic parameters.

## PARAMETERS

### -Name
The name of the Service template.
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
The description of the Service template.

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

### -Cardinality
Array of cardinality properties with name and type properties.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertySelector
Array of property selector objects for filtering.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Array of properties to add to the services with id, value, and type.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServiceNamingPattern
Array of strings defining the service naming pattern.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateGroup
Specifies whether to create groups for the service.
Default is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupNamingPattern
Array of strings defining the group naming pattern.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultCriticality
The default criticality level.
Default is "Medium".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Medium
Accept pipeline input: False
Accept wildcard characters: False
```

### -MembershipEvaluationInterval
The membership evaluation interval in minutes.
Default is 30.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 30
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterType
The filter type.
Default is "2".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceGroupRecords
{{ Fill ResourceGroupRecords Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -Criticality
{{ Fill Criticality Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: @()
Accept pipeline input: False
Accept wildcard characters: False
```

### -StaticGroup
{{ Fill StaticGroup Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: @()
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

### Returns LogicMonitor.ServiceTemplate object.
## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
