---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMWebsiteGroup

## SYNOPSIS
Updates a LogicMonitor website group configuration.

## SYNTAX

### Id-ParentGroupId (Default)
```
Set-LMWebsiteGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-ParentGroupId <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-ParentGroupName
```
Set-LMWebsiteGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>]
 [-ParentGroupName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-ParentGroupName
```
Set-LMWebsiteGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>]
 [-ParentGroupName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-ParentGroupId
```
Set-LMWebsiteGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-ParentGroupId <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Set-LMWebsiteGroup function modifies an existing website group in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Set-LMWebsiteGroup -Id 123 -NewName "Updated Group" -Description "New description" -ParentGroupId 456
Updates the website group with new name, description, and parent group.
```

## PARAMETERS

### -Id
Specifies the ID of the website group to modify.

```yaml
Type: String
Parameter Sets: Id-ParentGroupId, Id-ParentGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the current name of the website group.

```yaml
Type: String
Parameter Sets: Name-ParentGroupName, Name-ParentGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
Specifies the new name for the website group.

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
Specifies the description for the website group.

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

### -Properties
Specifies a hashtable of custom properties for the website group.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PropertiesMethod
Specifies how to handle properties.
Valid values: "Add", "Replace", "Refresh".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Replace
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Indicates whether to disable alerting for the website group.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopMonitoring
Indicates whether to stop monitoring the website group.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
Specifies the ID of the parent group.

```yaml
Type: Int32
Parameter Sets: Id-ParentGroupId, Name-ParentGroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
Specifies the name of the parent group.

```yaml
Type: String
Parameter Sets: Id-ParentGroupName, Name-ParentGroupName
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

### None.
## OUTPUTS

### Returns a LogicMonitor.WebsiteGroup object containing the updated configuration.
## NOTES
This function requires a valid LogicMonitor API authentication.

## RELATED LINKS
