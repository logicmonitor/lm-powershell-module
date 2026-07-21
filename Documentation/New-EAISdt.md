---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: New-EAISdt
---

# New-EAISdt

## SYNOPSIS

Creates a new Edwin scheduled downtime (SDT) entry.

## SYNTAX

### Default (Default)

```
New-EAISdt -Name <string> -Filter <Object> [-Description <string>] [-Enabled] [-Duration <int>]
 [-StartDate <datetime>] [-EndDate <datetime>] [-Timezone <string>]
 [-SdtType <string>] [-StartHour <int>] [-StartMinute <int>] [-EndHour <int>] [-EndMinute <int>]
 [-WeekDay <string[]>] [-WeekOfMonth <string>] [-DayOfMonth <int>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ScheduleWizard

```
New-EAISdt [-Name <string>] [-Description <string>] [-Filter <Object>] [-Enabled] [-ScheduleWizard]
 [-Duration <int>] [-StartDate <datetime>] [-EndDate <datetime>] [-Timezone <string>]
 [-SdtType <string>] [-StartHour <int>] [-StartMinute <int>] [-EndHour <int>] [-EndMinute <int>]
 [-WeekDay <string[]>] [-WeekOfMonth <string>] [-DayOfMonth <int>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION

New-EAISdt creates a maintenance window on the Edwin Action Service.
Use -ScheduleWizard for an interactive flow, or supply -Name, -Filter, and schedule parameters directly.

## EXAMPLES

### EXAMPLE 1

```
New-EAISdt -ScheduleWizard
```

### EXAMPLE 2

```
New-EAISdt -Name "Weekly window" -Duration 60 -SdtType Weekly -WeekDay Monday -Filter $filter
```

## PARAMETERS

### -Name

Display name for the schedule.

### -Filter

Filter condition object matching the Edwin filter schema (schemaName, schemaVersion, expression).

### -Enabled

When specified, creates the schedule enabled or disabled. Omit to create an enabled schedule.

### -ScheduleWizard

Launches an interactive wizard to create the schedule.

### -PassThru

Re-fetches and returns the created schedule after a successful create.

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### None by default. With -PassThru, returns an Edwin.SDT object.

## NOTES

Use Connect-EAIAccount to establish an Edwin session before running this command.

## RELATED LINKS
