---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMWebsiteGroup

## SYNOPSIS
Retrieves website group information from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMWebsiteGroup [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMWebsiteGroup [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMWebsiteGroup [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMWebsiteGroup [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### FilterWizard
```
Get-LMWebsiteGroup [-FilterWizard] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMWebsiteGroup function retrieves website group information from LogicMonitor based on specified parameters.
It can return a single website group by ID or multiple groups based on name, filter, or filter wizard.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve a website group by ID
Get-LMWebsiteGroup -Id 1234
```

### EXAMPLE 2
```
#Retrieve a website group by name
Get-LMWebsiteGroup -Name "Production"
```

### EXAMPLE 3
```
#Retrieve website groups using a filter
Get-LMWebsiteGroup -Filter $filterObject
```

## PARAMETERS

### -Id
The ID of the website group to retrieve.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the website group to retrieve.
This parameter is mandatory when using the Name parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving website groups.
This parameter is mandatory when using the Filter parameter set.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FilterWizard
A switch parameter to enable the filter wizard interface.
This parameter is mandatory when using the FilterWizard parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: FilterWizard
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Default is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### Returns LogicMonitor.WebsiteGroup objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
