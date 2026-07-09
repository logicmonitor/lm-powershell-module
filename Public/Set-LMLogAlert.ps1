<#
.SYNOPSIS
Updates a log alert processor in LogicMonitor.

.DESCRIPTION
The Set-LMLogAlert function modifies an existing log alert processor in LogicMonitor.
You can specify individual parameters or provide a complete configuration object using InputObject.
When -Disabled is specified, the enable/disable action endpoint is updated separately.

.PARAMETER Id
Specifies the ID of the log alert processor to modify.

.PARAMETER Name
Specifies the current name of the log alert processor.

.PARAMETER InputObject
A PSCustomObject containing the complete log alert processor configuration. Must include id or name.

.PARAMETER NewName
Specifies the new name for the log alert processor.

.PARAMETER PipelineId
Specifies the ID of the parent log alert group (pipeline).

.PARAMETER AlertQuery
Specifies the alert query for the processor.

.PARAMETER AlertType
Specifies the alert type for the processor.

.PARAMETER Severity
Specifies the severity level. Valid values: critical, error, warning, null.

.PARAMETER Description
Specifies the description for the processor.

.PARAMETER LogNotes
Specifies log notes for the processor.

.PARAMETER LogMetadataFields
Specifies an array of log metadata field names.

.PARAMETER Disabled
Specifies whether the processor is disabled.

.PARAMETER Clear
Clear configuration object with properties: autoClearAfter, clearQuery, groupingEntities, autoClearOnAck.

.PARAMETER Grouping
Grouping configuration object with property: alertEntities.

.PARAMETER Window
Window configuration object with properties: duration, count.

.EXAMPLE
Set-LMLogAlert -Id 5 -Description "Updated alert rule"

.EXAMPLE
Set-LMLogAlert -Name "High Error Rate" -Disabled $true

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns LogicMonitor.LogAlert object.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Set-LMLogAlert {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'InputObject')]
        [PSCustomObject]$InputObject,

        [String]$NewName,

        [Int]$PipelineId,

        [String]$AlertQuery,

        [String]$AlertType,

        [ValidateSet("critical", "error", "warning", "null")]
        [String]$Severity,

        [String]$Description,

        [String]$LogNotes,

        [String[]]$LogMetadataFields,

        [Boolean]$Disabled,

        [PSCustomObject]$Clear,

        [PSCustomObject]$Grouping,

        [PSCustomObject]$Window
    )

    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $Response = $null

            if ($PSCmdlet.ParameterSetName -eq 'InputObject') {
                if ($InputObject.id) {
                    $Id = $InputObject.id
                }
                elseif ($InputObject.name) {
                    $LookupResult = (Get-LMLogAlert -Name $InputObject.name).id
                    if (Test-LookupResult -Result $LookupResult -LookupString $InputObject.name) { return }
                    $Id = $LookupResult
                }
                else {
                    Write-Error "InputObject must contain either an 'id' or 'name' property."
                    return
                }
                $ResourcePath = "/logpipelines/processors/$Id"
                $Message = "Id: $Id | Name: $($InputObject.name)"
                $Data = $InputObject | ConvertTo-Json -Depth 10

                if ($PSCmdlet.ShouldProcess($Message, "Set Log Alert")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                    $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlert"
                }
            }
            else {
                if ($Name) {
                    $LogAlert = Get-LMLogAlert -Name $Name
                    if (Test-LookupResult -Result $LogAlert -LookupString $Name) {
                        return
                    }
                    $Id = $LogAlert.id
                }

                $ConfigKeys = @(
                    'NewName', 'PipelineId', 'AlertQuery', 'AlertType', 'Severity', 'Description',
                    'LogNotes', 'LogMetadataFields', 'Clear', 'Grouping', 'Window'
                )
                $HasConfigUpdate = $false
                foreach ($key in $ConfigKeys) {
                    if ($PSBoundParameters.ContainsKey($key)) {
                        $HasConfigUpdate = $true
                        break
                    }
                }

                if ($HasConfigUpdate) {
                    $ResourcePath = "/logpipelines/processors/$Id"
                    $Data = @{
                        name              = $NewName
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
                        -ConditionalKeep @{ 'name' = 'NewName' }

                    if ($PSItem) {
                        $Message = "Id: $Id | Name: $($PSItem.name)"
                    }
                    else {
                        $Message = "Id: $Id"
                    }

                    if ($PSCmdlet.ShouldProcess($Message, "Set Log Alert")) {
                        $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                        $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                        Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                        $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlert"
                    }
                }

                if ($PSBoundParameters.ContainsKey('Disabled')) {
                    $Action = if ($Disabled) { 'disable' } else { 'enable' }
                    $ActionPath = "/logpipelines/processors/$Id/$Action"
                    $ActionBody = (@{ value = $Disabled } | ConvertTo-Json)
                    $ActionMessage = "Id: $Id | Disabled: $Disabled"

                    if ($PSCmdlet.ShouldProcess($ActionMessage, "Set Log Alert Status")) {
                        $ActionHeaders = New-LMHeader -Auth $Script:LMAuth -Method "PUT" -ResourcePath $ActionPath -Data $ActionBody
                        $ActionUri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ActionPath
                        Resolve-LMDebugInfo -Url $ActionUri -Headers $ActionHeaders[0] -Command $MyInvocation -Payload $ActionBody
                        $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $ActionUri -Method "PUT" -Headers $ActionHeaders[0] -WebSession $ActionHeaders[1] -Body $ActionBody
                        $Response = Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogAlert"
                    }
                }
            }

            return $Response
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
