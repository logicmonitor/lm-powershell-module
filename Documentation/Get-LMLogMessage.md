---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMLogMessage

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Range-Async (Default)
```
Get-LMLogMessage [-Query <String>] [-Range <String>] [-BatchSize <Int32>] [-MaxPages <Int32>] [-Async]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Date-Async
```
Get-LMLogMessage -StartDate <DateTime> -EndDate <DateTime> [-Query <String>] [-BatchSize <Int32>]
 [-MaxPages <Int32>] [-Async] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Date-Sync
```
Get-LMLogMessage -StartDate <DateTime> -EndDate <DateTime> [-Query <String>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Range-Sync
```
Get-LMLogMessage [-Query <String>] [-Range <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -Async
{{ Fill Async Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Range-Async, Date-Async
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
{{ Fill BatchSize Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
{{ Fill EndDate Description }}

```yaml
Type: DateTime
Parameter Sets: Date-Async, Date-Sync
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxPages
{{ Fill MaxPages Description }}

```yaml
Type: Int32
Parameter Sets: Range-Async, Date-Async
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Query
{{ Fill Query Description }}

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

### -Range
{{ Fill Range Description }}

```yaml
Type: String
Parameter Sets: Range-Async, Range-Sync
Aliases:
Accepted values: 15min, 30min, 1hour, 3hour, 6hour, 12hour, 24hour, 3day, 7day, 1month

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
{{ Fill StartDate Description }}

```yaml
Type: DateTime
Parameter Sets: Date-Async, Date-Sync
Aliases:

Required: True
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
