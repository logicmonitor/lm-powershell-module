---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMServiceMember

## SYNOPSIS
Retrieves service member information from LogicMonitor.

## SYNTAX

### Id (Default)
```
Get-LMServiceMember -Id <Int32> [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DisplayName
```
Get-LMServiceMember -DisplayName <String> [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMServiceMember -Name <String> [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMServiceMember function retrieves service member information from LogicMonitor based on specified parameters.
It can return a single service member by ID or multiple service members based on name, display name, filter, or filter wizard.
It also supports delta tracking for monitoring changes.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve a service member by ID
Get-LMServiceMember -Id 123
```

## PARAMETERS

### -Id
The ID of the service to retrieve members from.
Part of a mutually exclusive parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DisplayName
The display name of the service to retrieve members from.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: DisplayName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the service to retrieve members from.
Part of a mutually exclusive parameter set.

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

### -BatchSize
The number of results to return per request.
Must be between 1 and 1000.
Defaults to 1000.

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

### None. You can pipe LogicMonitor.Device objects to this command.
## OUTPUTS

### Returns LogicMonitor.ServiceMember objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
