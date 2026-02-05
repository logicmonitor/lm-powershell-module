---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDiagnosticSource

## SYNOPSIS
Creates a new LogicMonitor diagnostic source.

## SYNTAX

### Default (Default)
```
New-LMDiagnosticSource -Name <String> [-Description <String>] [-AppliesTo <String>] [-Technology <String>]
 [-Tags <String>] [-Group <String>] [-ScriptType <String>] [-GroovyScript <String>] [-AccessGroupIds <Int32[]>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### InputObject
```
New-LMDiagnosticSource -InputObject <PSObject> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDiagnosticSource function creates a new diagnostic source in LogicMonitor.
You can
specify individual parameters or provide a complete configuration object using the InputObject parameter.

## EXAMPLES

### EXAMPLE 1
```
# Create a new diagnostic source using explicit parameters
New-LMDiagnosticSource -Name "MyDiagnosticSource" -Description "Checks service status" -ScriptType "powershell" -GroovyScript "Get-Service MyService"
```

### EXAMPLE 2
```
# Create a new diagnostic source using an InputObject
$config = @{
    name = "MyDiagnosticSource"
    description = "Checks service status"
    scriptType = "powershell"
    groovyScript = "Get-Service MyService"
}
New-LMDiagnosticSource -InputObject $config
```

## PARAMETERS

### -InputObject
A PSCustomObject containing the complete diagnostic source configuration.
Must follow the schema model
defined in LogicMonitor's API documentation.
Use this parameter for advanced or programmatic scenarios.

```yaml
Type: PSObject
Parameter Sets: InputObject
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the diagnostic source.
This parameter is mandatory when using explicit parameters.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description for the diagnostic source.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppliesTo
The AppliesTo expression for the diagnostic source.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Technology
The technical notes for the diagnostic source.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
The tags to associate with the diagnostic source.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Group
The group the diagnostic source belongs to.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptType
The script type for the diagnostic source.
Valid values are 'groovy' or 'powershell'.
Defaults to 'groovy'.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: Groovy
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroovyScript
The script content for the diagnostic source.

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessGroupIds
An array of Access Group IDs to assign to the diagnostic source.

```yaml
Type: Int32[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
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

### Returns LogicMonitor.DiagnosticSource object.
## NOTES
You must run Connect-LMAccount before running this command.
For diagnostic source schema details, see: https://www.logicmonitor.com/swagger-ui-master/api-v3/dist/#/DiagnosticSources/addDiagnosticSource

## RELATED LINKS
