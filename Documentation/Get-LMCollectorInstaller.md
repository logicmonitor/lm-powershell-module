---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Get-LMCollectorInstaller
---

# Get-LMCollectorInstaller

## SYNOPSIS

Downloads the LogicMonitor Collector installer.

## SYNTAX

### Id (Default)

```
Get-LMCollectorInstaller -Id <int> [-Size <string>] [-OSandArch <string>] [-UseEA <bool>]
 [-DownloadPath <string>] [<CommonParameters>]
```

### Name

```
Get-LMCollectorInstaller -Name <string> [-Size <string>] [-OSandArch <string>] [-UseEA <bool>]
 [-DownloadPath <string>] [<CommonParameters>]
```

## DESCRIPTION

The Get-LMCollectorInstaller function downloads the LogicMonitor Collector installer based on the specified parameters.
It supports different operating systems, architectures, and collector sizes, and can download either standard or Early Access (EA) versions.

## EXAMPLES

### EXAMPLE 1

#Download a Windows collector installer
Get-LMCollectorInstaller -Id 123 -Size medium -OSandArch Win64 -DownloadPath "C:\Downloads"

### EXAMPLE 2

#Download a Linux collector installer with Early Access
Get-LMCollectorInstaller -Name "Collector1" -OSandArch Linux64 -UseEA $true

## PARAMETERS

### -DownloadPath

The path where the installer file will be saved.
Defaults to the current directory.

```yaml
Type: System.String
DefaultValue: (Get-Location).Path
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Id

The ID of the collector to download the installer for.
This parameter is mandatory when using the Id parameter set.

```yaml
Type: System.Int32
DefaultValue: 0
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Id
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Name

The name of the collector to download the installer for.
This parameter is mandatory when using the Name parameter set.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Name
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -OSandArch

The operating system and architecture for the installer.
Valid values are 'Win64', 'Linux64'.
Defaults to 'Win64'.

```yaml
Type: System.String
DefaultValue: Win64
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -Size

The size of the collector to install.
Valid values are 'nano', 'small', 'medium', 'large', 'extra_large', 'double_extra_large'.
Defaults to 'medium'.

```yaml
Type: System.String
DefaultValue: medium
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -UseEA

Switch to use the Early Access version of the collector.
Defaults to $false.

```yaml
Type: System.Boolean
DefaultValue: False
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.

## OUTPUTS

### Returns the path to the downloaded installer file.

### System.String

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

