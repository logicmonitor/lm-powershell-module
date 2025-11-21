<#
.SYNOPSIS
Sends webhook events to LogicMonitor.

.DESCRIPTION
The Send-LMWebhookMessage function submits webhook messages to LogicMonitor for ingestion via the Webhook LogSource endpoint. Provide an array of events to transmit; each entry is converted into a JSON payload. Optional common properties can be merged into every event to support downstream parsing in LogicMonitor.

.PARAMETER SourceName
Specifies the LogicMonitor LogSource identifier used in the ingest URL. This typically matches the sourceName configured in LogicMonitor.

.PARAMETER Events
Specifies the collection of events to send. Each item may be a hashtable, PSCustomObject, or simple value. Simple values are wrapped in a payload under the `message` property.

.PARAMETER Properties
Specifies additional key/value pairs that are merged into every event payload before sending.

.PARAMETER Messages
Specifies the collection of messages/events to send. Each item may be a hashtable, PSCustomObject, or simple value.

.PARAMETER PassThru
Returns PSCustomObject entries containing status, payload, and optional error details for each attempted message.

.EXAMPLE
Send-LMWebhookMessage -SourceName "Meraki_CustomerA" -Messages $Messages -Properties @{ accountId = '12345' }
Sends each event in `$Messages` to the Meraki webhook LogSource, appending the `accountId` property to every payload.

.EXAMPLE
$jsonString = '{"eventType":"alert","severity":"critical","description":"Database connection failed"}'
Send-LMWebhookMessage -SourceName "MyWebhookSource" -Messages @($jsonString)
Sends a JSON string that will be automatically parsed and sent as structured data to the webhook endpoint.

.EXAMPLE
Send-LMWebhookMessage -SourceName "AppLogs" -Messages @("Application started successfully", "User login detected")
Sends plain text messages that will be wrapped in a message property for ingestion.

.EXAMPLE
$event = @{
    eventType = "deployment"
    version = "1.2.3"
    environment = "production"
    timestamp = (Get-Date).ToString("o")
}
Send-LMWebhookMessage -SourceName "Deployments" -Messages @($event) -PassThru
Sends a hashtable as a structured event and returns the result with status information.

.EXAMPLE
$events = @(
    [PSCustomObject]@{ eventType = "login"; user = "john.doe"; status = "success" }
    [PSCustomObject]@{ eventType = "logout"; user = "jane.smith"; status = "success" }
)
Send-LMWebhookMessage -SourceName "AuthEvents" -Messages $events -Properties @{ source = "AD"; region = "us-east-1" }
Sends multiple PSCustomObject events with additional properties merged into each payload.

.EXAMPLE
$jsonEvents = @(
    '{"metric":"cpu","value":85,"host":"server01"}'
    '{"metric":"memory","value":72,"host":"server01"}'
)
Send-LMWebhookMessage -SourceName "Metrics" -Messages $jsonEvents
Sends multiple JSON strings that will be automatically parsed and sent as individual structured events.

.OUTPUTS
Outputs a confirmation message for each accepted webhook event, or an error message if the request fails. When -PassThru is specified, returns PSCustomObject entries containing status, payload, and optional error details for each attempted message.
#>
function Send-LMWebhookMessage {

    [CmdletBinding()]
    param (

        [Parameter(Mandatory)]
        [String]$SourceName,

        [Parameter(Mandatory)]
        [Object[]]$Messages,

        [Hashtable]$Properties,

        [Switch]$PassThru
    )

    begin {
        if (-not $Properties) {
            $Properties = @{}
        }

        if ($PassThru) {
            $SentPayloads = New-Object System.Collections.Generic.List[pscustomobject]
        }
    }
    process {
        if (-not $Script:LMAuth.Valid) {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
            return
        }

        if ($Script:LMAuth.Type -ne "Bearer") {
            Write-Error "This cmdlet does not support LMv1 or SessionSync auth. Use Connect-LMAccount to login with the correct auth type and try again"
            return
        }

        $encodedSource = [System.Uri]::EscapeDataString($SourceName)
        $resourcePath = "/api/v1/webhook/ingest/$encodedSource"
        $uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $resourcePath

        foreach ($message in $Messages) {
            $payload = [ordered]@{}

            # Check if message is a JSON string and convert it
            if ($message -is [String]) {
                try {
                    $jsonObject = $message | ConvertFrom-Json -ErrorAction Stop
                    $message = $jsonObject
                }
                catch {
                    # Not valid JSON, treat as plain string message
                    $payload["message"] = $message
                }
            }

            if ($message -is [System.Collections.IDictionary]) {
                foreach ($key in $message.Keys) {
                    $payload[$key] = $message[$key]
                }
            }
            elseif ($message -is [PSCustomObject]) {
                foreach ($property in $message.PSObject.Properties) {
                    $payload[$property.Name] = $property.Value
                }
            }
            elseif (-not ($payload.Contains("message"))) {
                # Only wrap in message if not already handled above
                $payload["message"] = [String]$message
            }

            foreach ($propertyKey in $Properties.Keys) {
                $payload[$propertyKey] = $Properties[$propertyKey]
            }

            foreach ($key in @($payload.Keys)) {
                if ($null -eq $payload[$key]) {
                    $payload.Remove($key)
                }
            }

            $body = ConvertTo-Json -InputObject $payload -Depth 10

            $headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $resourcePath -Data $body

            Resolve-LMDebugInfo -Url $uri -Headers $headers[0] -Command $MyInvocation -Payload $body

            $response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $uri -Method "POST" -Headers $headers[0] -WebSession $headers[1] -Body $body
            $isAccepted = ($response -eq "Accepted")

            if ($isAccepted) {
                if ($PassThru) {
                    $SentPayloads.Add([pscustomobject]$payload)
                }
                else {
                    Write-Output "Webhook message accepted successfully."
                }
                continue
            }

            $statusMessage = "Error"
            if ($PassThru) {
                $SentPayloads.Add([pscustomobject]@{
                        status  = $statusMessage
                        payload = [pscustomobject]$payload
                        error   = [pscustomobject]@{
                            code  = $response.errors.code
                            error = $response.errors.error
                        }
                    })
            }

            Write-Error -Message "$($response.errors.code): $($response.errors.error)"
        }
    }
    end {
        if ($PassThru -and $SentPayloads -and $SentPayloads.Count -gt 0) {
            foreach ($result in $SentPayloads) {
                if (-not ($result.PSObject.Properties.Name -contains 'status')) {
                    $SentPayloads[$SentPayloads.IndexOf($result)] = [pscustomobject]@{
                        status  = "Accepted"
                        payload = $result
                    }
                }
            }
            $SentPayloads.ToArray()
        }
    }
}


