---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMDeviceDedupe

## SYNOPSIS
List and/or remove duplicte devices from a portal based on a specified device group and set of exclusion criteria.

## SYNTAX

### List
```
Invoke-LMDeviceDedupe [-ListDuplicates] [-DeviceGroupId <String>] [-IpExclusionList <String[]>]
 [-SysNameExclusionList <String[]>] [-ExcludeDeviceType <String[]>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Remove
```
Invoke-LMDeviceDedupe [-RemoveDuplicates] [-DeviceGroupId <String>] [-IpExclusionList <String[]>]
 [-SysNameExclusionList <String[]>] [-ExcludeDeviceType <String[]>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
List and/or remove duplicte devices from a portal based on a specified device group and set of exclusion criteria.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMDeviceDedupe -ListDuplicates -DeviceGroupId 8
```

## PARAMETERS

### -ListDuplicates
{{ Fill ListDuplicates Description }}

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveDuplicates
{{ Fill RemoveDuplicates Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Remove
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
{{ Fill DeviceGroupId Description }}

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

### -IpExclusionList
{{ Fill IpExclusionList Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SysNameExclusionList
{{ Fill SysNameExclusionList Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeDeviceType
Exclude K8s resources by default

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: @(8)
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

### None. Does not accept pipeline input.
## OUTPUTS

## NOTES
Additional arrays can be specified to exclude certain IPs, sysname and devicetypes from being used for duplicate comparison

## RELATED LINKS
