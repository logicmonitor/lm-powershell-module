---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAPIToken

## SYNOPSIS
Retrieves API tokens from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMAPIToken [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AdminId
```
Get-LMAPIToken [-AdminId <Int32>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-LMAPIToken [-Id <Int32>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### AccessId
```
Get-LMAPIToken [-AccessId <String>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAPIToken [-Filter <Object>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAPIToken function retrieves API tokens from LogicMonitor based on specified criteria.
It can return tokens by admin ID, token ID, access ID, or using filters.

## EXAMPLES

### EXAMPLE 1
```
#Retrieve tokens for a specific admin
Get-LMAPIToken -AdminId 1234
```

### EXAMPLE 2
```
#Retrieve a specific token by ID
Get-LMAPIToken -Id 5678
```

### EXAMPLE 3
```
#Retrieve bearer tokens only
Get-LMAPIToken -Type "Bearer"
```

## PARAMETERS

### -AdminId
The ID of the admin to retrieve tokens for.
Part of a mutually exclusive parameter set.

```yaml
Type: Int32
Parameter Sets: AdminId
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The ID of the specific API token to retrieve.
Part of a mutually exclusive parameter set.

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

### -AccessId
The access ID of the specific API token to retrieve.
Part of a mutually exclusive parameter set.

```yaml
Type: String
Parameter Sets: AccessId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
A filter object to apply when retrieving tokens.
Part of a mutually exclusive parameter set.

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

### -Type
The type of token to retrieve.
Valid values are "LMv1", "Bearer", "*".
Defaults to "*".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns LogicMonitor.APIToken objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
