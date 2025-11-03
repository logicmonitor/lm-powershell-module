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
Lists duplicate devices found based on the specified criteria.
Required for List parameter set.

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
Removes duplicate devices found based on the specified criteria.
Required for Remove parameter set.

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
Specifies the device group ID to search for duplicates.
If not specified, all devices will be checked.

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
Array of IP addresses to exclude from duplicate comparison.

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
Array of system names to exclude from duplicate comparison.

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
Array of device type IDs to exclude from duplicate comparison.
Default is @(8) which excludes K8s resources.

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
