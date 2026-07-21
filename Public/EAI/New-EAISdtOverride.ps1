<#
.SYNOPSIS
Adds an override to a single Edwin SDT instance.

.DESCRIPTION
New-EAISdtOverride skips or reschedules one occurrence of a schedule without changing the
underlying schedule definition.

Use -Skip to skip an instance. Use -NewStartTime and -NewEndTime to reschedule it.

.PARAMETER ScheduleId
Schedule ID (UUID). Optional when piping an Edwin.SDT.Instance object.

.PARAMETER OriginalStartTime
Canonical original instance start time. Used with -ScheduleId when not piping an instance.

.PARAMETER Skip
Skips the selected instance.

.PARAMETER NewStartTime
New start time for an adjusted instance.

.PARAMETER NewEndTime
New end time for an adjusted instance.

.PARAMETER Summary
Optional note stored with the override.

.PARAMETER PassThru
Re-fetches and returns the parent schedule after the override is added.

.EXAMPLE
$instances = Get-EAISdt -Id $id | Get-EAISdtInstance
$instances | Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' } |
    New-EAISdtOverride -Skip -Summary 'Holiday'

.EXAMPLE
$instance = Get-EAISdt -Id $id | Get-EAISdtInstance |
    Where-Object { $_.instanceId -like '*2026-07-22T16:00:00.000Z*' }
$instance | New-EAISdtOverride `
    -NewStartTime $instance.originalInstanceId.startTime `
    -NewEndTime $instance.originalInstanceId.startTime.AddHours(4)

.NOTES
Always pipe or filter to the specific instance you intend to change. Derive -NewStartTime and -NewEndTime from the
piped instance, not from Get-Date.

Use instance.originalInstanceId.startTime as the canonical original start time.
The instanceId property is formatted as scheduleId:isoStartTime for use with Remove-EAISdtOverride.

.INPUTS
You can pipe Edwin.SDT.Instance objects from Get-EAISdtInstance.

.OUTPUTS
None by default. With -PassThru, returns an Edwin.SDT object. Writes an informational success message when console logging is enabled.
#>
function New-EAISdtOverride {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Adjust')]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject,

        [String]$ScheduleId,

        $OriginalStartTime,

        [Parameter(ParameterSetName = 'Skip')]
        [Switch]$Skip,

        [Parameter(ParameterSetName = 'Adjust')]
        $NewStartTime,

        [Parameter(ParameterSetName = 'Adjust')]
        $NewEndTime,

        [String]$Summary,

        [Switch]$PassThru
    )

    begin {
        if (-not (Test-EAIAuth -CallerPSCmdlet $PSCmdlet)) {
            $script:SkipNewEAISdtOverride = $true
            return
        }

        $script:SkipNewEAISdtOverride = $false
    }

    process {
        if ($script:SkipNewEAISdtOverride) {
            return
        }

        $effectiveScheduleId = Resolve-EAISdtInstanceScheduleId -PipelineInput $InputObject -ScheduleId $ScheduleId
        $originalInstanceId = if ($null -ne $InputObject) {
            if ($InputObject.PSObject.Properties['originalInstanceId']) {
                ConvertTo-EAISdtInstanceIdObject -InputObject $InputObject.originalInstanceId
            }
            elseif ($InputObject.PSObject.Properties['instanceId']) {
                ConvertTo-EAISdtInstanceIdObject -InputObject $InputObject.instanceId
            }
        }
        elseif (-not [string]::IsNullOrWhiteSpace($ScheduleId) -and $null -ne $OriginalStartTime) {
            ConvertTo-EAISdtInstanceIdObject -ScheduleId $ScheduleId -OriginalStartTime $OriginalStartTime
        }
        else {
            throw 'Provide an Edwin.SDT.Instance from the pipeline, or specify -ScheduleId with -OriginalStartTime.'
        }

        $payloadParams = @{
            OriginalInstanceId = $originalInstanceId
        }

        if ($PSCmdlet.ParameterSetName -eq 'Skip') {
            $payloadParams.Skip = $true
        }
        else {
            $payloadParams.NewStartTime = $NewStartTime
            $payloadParams.NewEndTime = $NewEndTime
        }

        if ($PSBoundParameters.ContainsKey('Summary')) {
            $payloadParams.Summary = $Summary
        }

        $payload = Build-EAISdtOverridePayload @payloadParams
        $body = $payload | ConvertTo-Json -Depth 10 -Compress
        $headers = New-EAIHeader -Auth $Script:EAIAuth -Method 'POST'
        $uri = Join-EAIUri -PortalUrl $Script:EAIAuth.PortalUrl -ResourcePath "/action/sdt/$effectiveScheduleId/override"
        $target = "ScheduleId: $effectiveScheduleId | Instance: $($originalInstanceId.startTime)"
        $enableDebugLogging = $DebugPreference -ne 'SilentlyContinue'

        if ($PSCmdlet.ShouldProcess($target, 'Add Edwin SDT override')) {
            Resolve-EAIDebugInfo -Url $uri -Headers $headers -Command $MyInvocation -Payload $body

            $null = Invoke-EAIRestMethod -Uri $uri -Method POST -Headers $headers -Auth $Script:EAIAuth `
                -Body $body -CallerPSCmdlet $PSCmdlet -EnableDebugLogging:$enableDebugLogging

            if ($PassThru) {
                return Get-EAISdt -Id $effectiveScheduleId
            }

            Write-Information "[INFO]: Successfully added Edwin SDT override for instance $($originalInstanceId.startTime) on schedule $effectiveScheduleId."
        }
    }
}
