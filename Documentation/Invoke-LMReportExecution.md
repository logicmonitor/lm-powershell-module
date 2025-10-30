---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMReportExecution

## SYNOPSIS
Triggers the execution of a LogicMonitor report.

## SYNTAX

### Id (Default)
```
Invoke-LMReportExecution -Id <Int32> [-WithAdminId <Int32>] [-ReceiveEmails <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Invoke-LMReportExecution -Name <String> [-WithAdminId <Int32>] [-ReceiveEmails <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-LMReportExecution starts an on-demand run of a LogicMonitor report.
The report can be
identified by ID or name.
Optional parameters allow impersonating another admin or overriding the
email recipients for the generated output.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMReportExecution -Id 42
```

Starts an immediate execution of the report with ID 42 using the current user's context.

### EXAMPLE 2
```
Invoke-LMReportExecution -Name "Monthly Availability" -WithAdminId 101 -ReceiveEmails "ops@example.com"
```

Runs the "Monthly Availability" report as admin ID 101 and emails the results to ops@example.com.

## PARAMETERS

### -Id
The ID of the report to execute.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the report to execute.

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

### -WithAdminId
The admin ID to impersonate when generating the report.
Defaults to the current user when omitted.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReceiveEmails
One or more email addresses (comma-separated) that should receive the generated report.

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
