---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMUptimeWebStep

## SYNOPSIS
Creates a LogicMonitor Uptime web step definition.

## SYNTAX

### External (Default)
```
New-LMUptimeWebStep [-Name <String>] [-Url <String>] [-HttpMethod <String>] [-HttpVersion <String>]
 -Type <String> [-Enable <Boolean>] [-UseDefaultRoot <Boolean>] [-Schema <String>]
 [-FollowRedirection <Boolean>] [-FullPageLoad <Boolean>] [-RequireAuth <Boolean>] [-AuthType <String>]
 [-AuthUserName <String>] [-AuthPassword <String>] [-AuthDomain <String>] [-HttpHeaders <String>]
 [-HttpBody <String>] [-RequestType <String>] [-ResponseType <String>] [-MatchType <String>]
 [-Keyword <String>] [-InvertMatch] [-StatusCode <String>] [-Path <String>] [-Label <String>]
 [-Description <String>] [-TimeoutInSeconds <Int32>] [-PostDataEditType <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Internal
```
New-LMUptimeWebStep [-Name <String>] [-Url <String>] [-HttpMethod <String>] [-HttpVersion <String>]
 -Type <String> [-Enable <Boolean>] [-UseDefaultRoot <Boolean>] [-Schema <String>]
 [-FollowRedirection <Boolean>] [-FullPageLoad <Boolean>] [-RequireAuth <Boolean>] [-AuthType <String>]
 [-AuthUserName <String>] [-AuthPassword <String>] [-AuthDomain <String>] [-HttpHeaders <String>]
 [-HttpBody <String>] [-RequestType <String>] [-ResponseType <String>] [-MatchType <String>]
 [-Keyword <String>] [-InvertMatch] [-StatusCode <String>] [-Path <String>] [-Label <String>]
 [-Description <String>] [-TimeoutInSeconds <Int32>] [-PostDataEditType <String>] [-ResponseScript <String>]
 [-RequestScript <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
New-LMUptimeWebStep generates a hashtable describing a single web step compatible with the
New-LMUptimeDevice and Set-LMUptimeDevice cmdlets.
Separate parameter sets target external
(config) steps and internal (script-capable) steps while enforcing the appropriate schema
constraints.

## EXAMPLES

### EXAMPLE 1
```
New-LMUptimeWebStep -Type External -Name '__home' -Url '/' -Keyword 'Welcome' -StatusCode '200'
```

### EXAMPLE 2
```
New-LMUptimeWebStep -Type Internal -RequestType script -RequestScript $scriptBlock
```

## PARAMETERS

### -Name
Step name.
Defaults to "__step0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: __step0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Url
Relative or absolute URL to execute.
Defaults to empty string.

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

### -HttpMethod
HTTP method executed by the step.
Valid values: GET, HEAD, POST.
Defaults to GET.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -HttpVersion
HTTP protocol version.
Valid values: 1, 1.1.
Defaults to 1.1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1.1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Controls whether the step is treated as external (config) or internal (script).
External set uses Type "config"; internal may use "script" or "config".

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

### -Enable
Indicates whether the step is enabled.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultRoot
Indicates whether the default root should be used.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schema
HTTP schema value (http or https).
Defaults to https.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Https
Accept pipeline input: False
Accept wildcard characters: False
```

### -FollowRedirection
Indicates whether redirects are automatically followed.
Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -FullPageLoad
Indicates whether full page load is required.
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

### -RequireAuth
Indicates whether authentication is required.
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

### -AuthType
Authentication type when RequireAuth is true.
Defaults to basic.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Basic
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthUserName
Authentication username.

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

### -AuthPassword
Authentication password.

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

### -AuthDomain
Authentication domain.

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

### -HttpHeaders
Optional HTTP headers string.

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

### -HttpBody
Optional HTTP body content.

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

### -RequestType
Request type.
External steps support config only; internal steps allow config or script.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResponseType
Response type.
External steps support plain text/string, glob expression, JSON, XML, multi line key value pair; internal steps additionally support script.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Plain text/string
Accept pipeline input: False
Accept wildcard characters: False
```

### -MatchType
Match type used for response evaluation.
Defaults to plain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Plain
Accept pipeline input: False
Accept wildcard characters: False
```

### -Keyword
Keyword used during response evaluation.

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

### -InvertMatch
Switch to invert keyword matching behaviour.

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

### -StatusCode
Expected status code string.

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

### -Path
Optional path field for JSON/XPATH matching.

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

### -Label
Optional step label.

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

### -Description
Optional step description.

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

### -TimeoutInSeconds
Optional timeout expressed in seconds.

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

### -PostDataEditType
POST data edit type (Raw or Formatted Data).

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

### -ResponseScript
Response script content (internal parameter set only).

```yaml
Type: String
Parameter Sets: Internal
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequestScript
Request script content (internal parameter set only).

```yaml
Type: String
Parameter Sets: Internal
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

### Hashtable describing an uptime web step.
## NOTES

## RELATED LINKS
