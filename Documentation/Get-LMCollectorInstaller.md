---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorInstaller

## SYNOPSIS
Downloads the LogicMonitor Collector installer.

## SYNTAX

### Id (Default)
```
Get-LMCollectorInstaller -Id <Int32> [-Size <String>] [-OSandArch <String>] [-UseEA <Boolean>]
 [-DownloadPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMCollectorInstaller -Name <String> [-Size <String>] [-OSandArch <String>] [-UseEA <Boolean>]
 [-DownloadPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorInstaller function downloads the LogicMonitor Collector installer based on the specified parameters.
It supports different operating systems, architectures, and collector sizes, and can download either standard or Early Access (EA) versions.

## EXAMPLES

### EXAMPLE 1
```
#Download a Windows collector installer
Get-LMCollectorInstaller -Id 123 -Size medium -OSandArch Win64 -DownloadPath "C:\Downloads"
```

### EXAMPLE 2
```
#Download a Linux collector installer with Early Access
Get-LMCollectorInstaller -Name "Collector1" -OSandArch Linux64 -UseEA $true
```

## PARAMETERS

### -Id
The ID of the collector to download the installer for.
This parameter is mandatory when using the Id parameter set.

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
The name of the collector to download the installer for.
This parameter is mandatory when using the Name parameter set.

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

### -Size
The size of the collector to install.
Valid values are 'nano', 'small', 'medium', 'large', 'extra_large', 'double_extra_large'.
Defaults to 'medium'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Medium
Accept pipeline input: False
Accept wildcard characters: False
```

### -OSandArch
The operating system and architecture for the installer.
Valid values are 'Win64', 'Linux64'.
Defaults to 'Win64'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Win64
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseEA
Switch to use the Early Access version of the collector.
Defaults to $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DownloadPath
The path where the installer file will be saved.
Defaults to the current directory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
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

### Returns the path to the downloaded installer file.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
