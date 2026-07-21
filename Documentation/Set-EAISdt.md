---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/21/2026
PlatyPS schema version: 2024-05-01
title: Set-EAISdt
---

# Set-EAISdt

## SYNOPSIS

Updates an existing Edwin scheduled downtime (SDT) entry.

## SYNTAX

### Default (Default)

```
Set-EAISdt -Id <string> [-Name <string>] [-Description <string>] [-Enabled] [-Filter <Object>]
 [-SdtType <string>] [-StartHour <int>] [-StartMinute <int>] [-EndHour <int>] [-EndMinute <int>]
 [-WeekDay <string[]>] [-WeekOfMonth <string>] [-DayOfMonth <int>] [-PassThru] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### ScheduleWizard

```
Set-EAISdt [-Id <string>] [-ScheduleWizard] [-Name <string>] [-Description <string>] [-Enabled]
 [-Filter <Object>] [-SdtType <string>] [-StartHour <int>] [-StartMinute <int>] [-EndHour <int>]
 [-EndMinute <int>] [-WeekDay <string[]>] [-WeekOfMonth <string>] [-DayOfMonth <int>] [-PassThru]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Set-EAISdt applies partial updates to an Edwin SDT schedule via metadata, filter, and recurrence endpoints.
Use Set-EAISdt -Enabled:$false to disable a schedule. There is no delete endpoint.

## EXAMPLES

### EXAMPLE 1

```
Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -Enabled:$false
```

### EXAMPLE 2

```
Set-EAISdt -Id '6d18821f-8f3c-48ca-8331-3e4c8d77cac3' -SdtType Weekly -WeekDay Monday, Thursday `
    -StartHour 13 -StartMinute 0 -EndHour 14 -EndMinute 0
```

## PARAMETERS

### -Id

Schedule ID (UUID).

### -Enabled

Enables or disables the schedule via the metadata endpoint.

### -Filter

Updates the filter condition via the filter endpoint.

### -PassThru

Re-fetches and returns the updated schedule after all updates succeed.

## INPUTS

### You can pipe Edwin.SDT objects (scheduleId), objects with an Id property, or schedule ID strings.

## OUTPUTS

### None by default. With -PassThru, returns an Edwin.SDT object.

## NOTES

Use Connect-EAIAccount to establish an Edwin session before running this command.
startTime and duration cannot be changed after create.

## RELATED LINKS
