<#
.SYNOPSIS
Sends events to Edwin for ingestion.

.DESCRIPTION
Send-EAIEvents posts one or more Common Event Format (CEF) payloads to Edwin.
Use this cmdlet for custom third-party event data. LogicMonitor alerts are already sent to Edwin natively.

.PARAMETER Events
One or more event objects containing cef and enrichments properties.

.PARAMETER PassThru
Returns per-event Edwin API acceptance results.

.EXAMPLE
$event = @{
    cef = @{
        event_ci = 'server01'
        event_object = 'CPU'
        event_source = 'Meraki'
        event_name = 'High CPU'
        event_description = 'CPU above threshold'
        event_severity = 4
        event_time = (Format-EAIEventTime -DateTime (Get-Date))
        event_id = [guid]::NewGuid().ToString()
        event_domain = ''
        source_record = @{ device = 'server01' }
        class = 'event'
        version = '1.1'
    }
    enrichments = @{}
}
Send-EAIEvents -Events $event

.NOTES
LogicMonitor portal authentication is not required for Edwin event ingestion.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
By default, writes an informational success message. With -PassThru, returns Edwin API response objects.
#>
function Send-EAIEvents {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory, ValueFromPipeline)]
        [Object[]]$Events,

        [Switch]$PassThru
    )

    begin {
        if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
            return
        }

        $batch = [System.Collections.Generic.List[object]]::new()
    }

    process {
        foreach ($event in $Events) {
            $normalized = Test-EAIEventPayload -Event $event
            $batch.Add($normalized)
        }
    }

    end {
        if ($batch.Count -eq 0) {
            Write-Error 'No events were provided to Send-EAIEvents.'
            return
        }

        $body = ConvertTo-Json -InputObject @($batch) -Depth 20
        $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'POST'
        $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath '/integration/event/v1'
        $target = "$($batch.Count) Edwin event(s)"
        $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

        if ($PSCmdlet.ShouldProcess($target, 'Send to Edwin')) {
            Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation -Payload $body

            $response = Invoke-EAIRestMethod -Uri $uri -Method POST -Headers $headers -Auth $Script:EAIAuth -Body $body `
                -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

            if ($PassThru) {
                return $response
            }

            Write-Information "[INFO]: Successfully sent $($batch.Count) event(s) to Edwin."
        }
    }
}
