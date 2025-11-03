---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Send-LMWebhookMessage

## SYNOPSIS
Sends webhook events to LogicMonitor.

## SYNTAX

```
Send-LMWebhookMessage [-SourceName] <String> [-Messages] <Object[]> [[-Properties] <Hashtable>] [-PassThru]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Send-LMWebhookMessage function submits webhook messages to LogicMonitor for ingestion via the Webhook LogSource endpoint.
Provide an array of events to transmit; each entry is converted into a JSON payload.
Optional common properties can be merged into every event to support downstream parsing in LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Send-LMWebhookMessage -SourceName "Meraki_CustomerA" -Events $Messages -Properties @{ accountId = '12345' }
Sends each event in `$Messages` to the Meraki webhook LogSource, appending the `accountId` property to every payload.
```

## PARAMETERS

### -SourceName
Specifies the LogicMonitor LogSource identifier used in the ingest URL.
This typically matches the sourceName configured in LogicMonitor.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Messages
Specifies the collection of messages/events to send.
Each item may be a hashtable, PSCustomObject, or simple value.

```yaml
Type: Object[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
Specifies additional key/value pairs that are merged into every event payload before sending.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Returns PSCustomObject entries containing status, payload, and optional error details for each attempted message.

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

### Outputs a confirmation message for each accepted webhook event, or an error message if the request fails. When -PassThru is specified, returns PSCustomObject entries containing status, payload, and optional error details for each attempted message.
## NOTES

## RELATED LINKS
