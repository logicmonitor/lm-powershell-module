---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMReportExecutionTask

## SYNOPSIS
Retrieves the status of a LogicMonitor report execution task.

## SYNTAX

### ReportId (Default)
```
Get-LMReportExecutionTask -ReportId <Int32> -TaskId <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### ReportName
```
Get-LMReportExecutionTask -ReportName <String> -TaskId <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get-LMReportExecutionTask fetches information about a previously triggered report execution task.
Supply the report identifier (ID or name) along with the task ID returned from
Invoke-LMReportExecution to check completion status or retrieve the result URL.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMReportExecution -Id 42 | Select-Object -ExpandProperty taskId | Get-LMReportExecutionTask -ReportId 42
```

Gets the execution status for the specified report/task combination.

### EXAMPLE 2
```
$task = Invoke-LMReportExecution -Name "Monthly Availability"
Get-LMReportExecutionTask -ReportName "Monthly Availability" -TaskId $task.taskId
```

Checks the task status for the report by name.

## PARAMETERS

### -ReportId
The ID of the report whose execution task should be retrieved.

```yaml
Type: Int32
Parameter Sets: ReportId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportName
The name of the report whose execution task should be retrieved.

```yaml
Type: String
Parameter Sets: ReportName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TaskId
The execution task identifier returned when the report was triggered.

```yaml
Type: String
Parameter Sets: (All)
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

## OUTPUTS

## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
