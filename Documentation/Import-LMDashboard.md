---
document type: cmdlet
external help file: Logic.Monitor-help.xml
HelpUri: ''
Locale: en-US
Module Name: Logic.Monitor
ms.date: 07/10/2026
PlatyPS schema version: 2024-05-01
title: Import-LMDashboard
---

# Import-LMDashboard

## SYNOPSIS

Imports LogicMonitor dashboards from various sources.

## SYNTAX

### FilePath-GroupName

```
Import-LMDashboard -FilePath <string> -ParentGroupName <string> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

### FilePath-GroupId

```
Import-LMDashboard -FilePath <string> -ParentGroupId <string> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

### File-GroupName

```
Import-LMDashboard -File <string> -ParentGroupName <string> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

### File-GroupId

```
Import-LMDashboard -File <string> -ParentGroupId <string> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

### Repo-GroupName

```
Import-LMDashboard -GithubUserRepo <string> -ParentGroupName <string> [-GithubAccessToken <string>]
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

### Repo-GroupId

```
Import-LMDashboard -GithubUserRepo <string> -ParentGroupId <string> [-GithubAccessToken <string>]
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <string>] [<CommonParameters>]
```

## DESCRIPTION

The Import-LMDashboard function allows you to import LogicMonitor dashboards from different sources, such as local files, GitHub repositories, or LogicMonitor dashboard groups.
It supports importing dashboards in JSON format.

## EXAMPLES

### EXAMPLE 1

#Import dashboards from a directory
Import-LMDashboard -FilePath "C:\Dashboards" -ParentGroupId 12345 -ReplaceAPITokensOnImport -APIToken $apiToken

### EXAMPLE 2

#Import dashboards from GitHub
Import-LMDashboard -GithubUserRepo "username/repo" -ParentGroupName "MyDashboards" -ReplaceAPITokensOnImport -APIToken $apiToken

## PARAMETERS

### -APIToken

The API token to use when replacing tokens in imported dashboards.

```yaml
Type: System.Object
DefaultValue: ''
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

### -File

Specifies a single JSON dashboard file to import.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: File-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -FilePath

Specifies the path to a local file or directory containing the JSON dashboard files to import.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: FilePath-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FilePath-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GithubAccessToken

Specifies the GitHub access token for authenticated requests.
Required for large repositories due to API rate limits.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Repo-GroupName
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Repo-GroupId
  Position: Named
  IsRequired: false
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -GithubUserRepo

Specifies the GitHub repository (in the format "username/repo") from which to import JSON dashboard files.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Repo-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: Repo-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupId

The ID of the parent dashboard group where imported dashboards will be placed.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Repo-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FilePath-GroupId
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -ParentGroupName

The name of the parent dashboard group where imported dashboards will be placed.

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: Repo-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: File-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
- Name: FilePath-GroupName
  Position: Named
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### -PrivateUserName

The username of dashboard owner when creating dashboard as private.

```yaml
Type: System.String
DefaultValue: ''
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

### -ReplaceAPITokensOnImport

Switch to replace API tokens in imported dashboards with a dynamically generated token.

```yaml
Type: System.Management.Automation.SwitchParameter
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

### Returns imported dashboard objects.

## NOTES

You must run Connect-LMAccount before running this command.

## RELATED LINKS

