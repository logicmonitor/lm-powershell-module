---
external help file: Logic.Monitor-help.xml
Module Name: Dev.Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMDashboard

## SYNOPSIS
Imports LogicMonitor dashboards from various sources.

## SYNTAX

### FilePath-GroupName
```
Import-LMDashboard -FilePath <String> -ParentGroupName <String> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FilePath-GroupId
```
Import-LMDashboard -FilePath <String> -ParentGroupId <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File-GroupName
```
Import-LMDashboard -File <String> -ParentGroupName <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File-GroupId
```
Import-LMDashboard -File <String> -ParentGroupId <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Repo-GroupName
```
Import-LMDashboard -GithubUserRepo <String> [-GithubAccessToken <String>] -ParentGroupName <String>
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Repo-GroupId
```
Import-LMDashboard -GithubUserRepo <String> [-GithubAccessToken <String>] -ParentGroupId <String>
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMDashboard function allows you to import LogicMonitor dashboards from different sources, such as local files, GitHub repositories, or LogicMonitor dashboard groups.
It supports importing dashboards in JSON format.

## EXAMPLES

### EXAMPLE 1
```
#Import dashboards from a directory
Import-LMDashboard -FilePath "C:\Dashboards" -ParentGroupId 12345 -ReplaceAPITokensOnImport -APIToken $apiToken
```

### EXAMPLE 2
```
#Import dashboards from GitHub
Import-LMDashboard -GithubUserRepo "username/repo" -ParentGroupName "MyDashboards" -ReplaceAPITokensOnImport -APIToken $apiToken
```

## PARAMETERS

### -FilePath
Specifies the path to a local file or directory containing the JSON dashboard files to import.

```yaml
Type: String
Parameter Sets: FilePath-GroupName, FilePath-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Specifies a single JSON dashboard file to import.

```yaml
Type: String
Parameter Sets: File-GroupName, File-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GithubUserRepo
Specifies the GitHub repository (in the format "username/repo") from which to import JSON dashboard files.

```yaml
Type: String
Parameter Sets: Repo-GroupName, Repo-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GithubAccessToken
Specifies the GitHub access token for authenticated requests.
Required for large repositories due to API rate limits.

```yaml
Type: String
Parameter Sets: Repo-GroupName, Repo-GroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
The ID of the parent dashboard group where imported dashboards will be placed.

```yaml
Type: String
Parameter Sets: FilePath-GroupId, File-GroupId, Repo-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent dashboard group where imported dashboards will be placed.

```yaml
Type: String
Parameter Sets: FilePath-GroupName, File-GroupName, Repo-GroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReplaceAPITokensOnImport
Switch to replace API tokens in imported dashboards with a dynamically generated token.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -APIToken
The API token to use when replacing tokens in imported dashboards.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateUserName
The username of dashboard owner when creating dashboard as private.

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

### None. You cannot pipe objects to this command.
## OUTPUTS

### Returns imported dashboard objects.
## NOTES
You must run Connect-LMAccount before running this command.

## RELATED LINKS
