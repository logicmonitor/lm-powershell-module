<#
.SYNOPSIS
Updates a LogicMonitor diagnostic source configuration.

.DESCRIPTION
The Set-LMDiagnosticSource function modifies an existing diagnostic source in LogicMonitor, allowing updates to its name, description, group, script, tags, technology, appliesTo, and other properties.

.PARAMETER Id
Specifies the ID of the diagnostic source to modify. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the current name of the diagnostic source. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER NewName
Specifies the new name for the diagnostic source.

.PARAMETER Description
Specifies the new description for the diagnostic source.

.PARAMETER Group
Specifies the group for the diagnostic source.

.PARAMETER GroovyScript
Specifies the Groovy script for the diagnostic source.

.PARAMETER Tags
Specifies tags to associate with the diagnostic source.

.PARAMETER Technology
Specifies the technology details for the diagnostic source.

.PARAMETER AppliesTo
Specifies the appliesTo expression for the diagnostic source.

.EXAMPLE
Set-LMDiagnosticSource -Id 123 -NewName "UpdatedSource" -Description "New description"
Updates the diagnostic source with ID 123 with a new name and description.

.INPUTS
You can pipe objects containing Id properties to this function.

.OUTPUTS
Returns a LogicMonitor.DiagnosticSource object containing the updated diagnostic source information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
Function Set-LMDiagnosticSource {
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,
        [String]$Description,
        [String]$Group,
        [String]$GroovyScript,
        [String]$Tags,
        [String]$Technology,
        [String]$AppliesTo
    )
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            If ($Name) {
                $LookupResult = (Get-LMDiagnosticSource -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) { return }
                $Id = $LookupResult
            }
            $ResourcePath = "/setting/diagnosticssources/$Id"
            $Message = "Id: $Id | Name: $Name"
            Try {
                $Data = @{
                    name            = $NewName
                    description     = $Description
                    group           = $Group
                    groovyScript    = $GroovyScript
                    tags            = $Tags -join ","
                    technology      = $Technology
                    appliesTo       = $AppliesTo
                }
                # Remove empty keys so we don't overwrite them, with special handling for 'name'/'NewName'
                @($Data.Keys) | ForEach-Object {
                    if ($_ -eq 'name') {
                        if ('NewName' -notin $PSBoundParameters.Keys) { $Data.Remove($_) }
                    } else {
                        if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) }
                    }
                }

                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set DiagnosticSource")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data

                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DiagnosticSource")
                }
            } Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) { Return }
            }
        } Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
} 