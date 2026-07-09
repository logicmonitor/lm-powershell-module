<#
.SYNOPSIS
Creates a new log alert processor in LogicMonitor.

.DESCRIPTION
The New-LMLogAlert function creates a new log alert processor in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.
When -Disabled is specified, the enable/disable action endpoint is called after creation.

.PARAMETER InputObject
A PSCustomObject containing the complete log alert processor configuration.

.PARAMETER Name
The name of the log alert processor. Mandatory when using explicit parameters.

.PARAMETER PipelineId
The ID of the parent log alert group (pipeline). Mandatory when using explicit parameters.

.PARAMETER AlertQuery
The alert query for the processor.

.PARAMETER AlertType
The alert type for the processor.

.PARAMETER Severity
The severity level. Valid values: critical, error, warning, null.

.PARAMETER Description
The description for the processor.

.PARAMETER LogNotes
Log notes for the processor.

.PARAMETER LogMetadataFields
An array of log metadata field names.

.PARAMETER Disabled
Whether the processor is disabled after creation.

.PARAMETER Clear
Clear configuration object with properties: autoClearAfter, clearQuery, groupingEntities, autoClearOnAck.

.PARAMETER Grouping
Grouping configuration object with property: alertEntities.

.PARAMETER Window
Window configuration object with properties: duration, count.

.EXAMPLE
New-LMLogAlert -Name "High Error Rate" -PipelineId 10 -AlertQuery "level:error" -Severity error

.EXAMPLE
$config = Get-LMLogAlert -Id 5
New-LMLogAlert -InputObject $config

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogAlert object.
#>
function New-LMLogAlert {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None', DefaultParameterSetName = 'Default')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [Int]$PipelineId,

        [Parameter(ParameterSetName = 'Default')]
        [String]$AlertQuery,

        [Parameter(ParameterSetName = 'Default')]
        [String]$AlertType,

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("critical", "error", "warning", "null")]
        [String]$Severity,

        [Parameter(ParameterSetName = 'Default')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [String]$LogNotes,

        [Parameter(ParameterSetName = 'Default')]
        [String[]]$LogMetadataFields,

        [Parameter(ParameterSetName = 'Default')]
        [Boolean]$Disabled,

        [Parameter(ParameterSetName = 'Default')]
        [PSCustomObject]$Clear,

        [Parameter(ParameterSetName = 'Default')]
        [PSCustomObject]$Grouping,

        [Parameter(ParameterSetName = 'Default')]
        [PSCustomObject]$Window
    )
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ResourcePath = "/logpipelines/processors"

            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                $Message = "LogAlert Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10
            }
            else {
                $Message = "LogAlert Name: $Name | PipelineId: $PipelineId"
                $Data = @{
                    name              = $Name
                    pipelineId        = $PipelineId
                    alertQuery        = $AlertQuery
                    alertType         = $AlertType
                    severity          = $Severity
                    description       = $Description
                    logNotes          = $LogNotes
                    logMetadataFields = $LogMetadataFields
                    clear             = $Clear
                    grouping          = $Grouping
                    window            = $Window
                }

                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys `
                    -AlwaysKeepKeys @('name', 'pipelineId')
            }

            if ($PSCmdlet.ShouldProcess($Message, "New Log Alert")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlert"

                if ($PSBoundParameters.ContainsKey('Disabled')) {
                    $Action = if ($Disabled) { 'disable' } else { 'enable' }
                    $ActionPath = "/logpipelines/processors/$($Response.id)/$Action"
                    $ActionBody = (@{ value = $Disabled } | ConvertTo-Json)
                    $ActionHeaders = New-LMHeader -Auth $Script:LMAuth -Method "PUT" -ResourcePath $ActionPath -Data $ActionBody
                    $ActionUri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ActionPath
                    Resolve-LMDebugInfo -Url $ActionUri -Headers $ActionHeaders[0] -Command $MyInvocation -Payload $ActionBody
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $ActionUri -Method "PUT" -Headers $ActionHeaders[0] -WebSession $ActionHeaders[1] -Body $ActionBody
                    $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlert"
                }

                return $Response
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
