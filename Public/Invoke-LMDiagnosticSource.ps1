<#
.SYNOPSIS
Triggers a diagnostic source execution for a host.

.DESCRIPTION
The Invoke-LMDiagnosticSource function manually triggers a diagnostic source execution for a
LogicMonitor host. The host can be identified by ID, name, or display name, and the diagnostic
source can be identified by ID or name.

.PARAMETER Id
The host ID to run the diagnostic source against. Alias: HostId.

.PARAMETER Name
The host name to run the diagnostic source against. Alias: HostName.

.PARAMETER DisplayName
The host display name to run the diagnostic source against.

.PARAMETER DiagnosticId
The diagnostic source ID to execute.

.PARAMETER DiagnosticName
The diagnostic source name to execute.

.PARAMETER AlertId
Optional alert ID associated with this diagnostic execution.

.EXAMPLE
Invoke-LMDiagnosticSource -Id 123 -DiagnosticId 456

Triggers diagnostic source ID 456 on host ID 123.

.EXAMPLE
Invoke-LMDiagnosticSource -HostName "server01" -DiagnosticName "Disk Troubleshooter" -AlertId "A123456"

Looks up host and diagnostic source by name, then triggers a diagnostic execution associated with alert A123456.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.DiagnosticSourceExecution object.
#>
function Invoke-LMDiagnosticSource {

    [CmdletBinding(DefaultParameterSetName = 'Id-diagnosticId')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-diagnosticId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-diagnosticName', ValueFromPipelineByPropertyName)]
        [Alias('HostId', 'DeviceId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-diagnosticId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-diagnosticName')]
        [Alias('HostName', 'DeviceName')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'DisplayName-diagnosticId')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-diagnosticName')]
        [Alias('HostDisplayName', 'DeviceDisplayName')]
        [String]$DisplayName,

        [Parameter(Mandatory, ParameterSetName = 'Id-diagnosticId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-diagnosticId')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-diagnosticId')]
        [Int]$DiagnosticId,

        [Parameter(Mandatory, ParameterSetName = 'Id-diagnosticName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-diagnosticName')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-diagnosticName')]
        [String]$DiagnosticName,

        [String]$AlertId
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    $HostId = $null
    $ResolvedDiagnosticId = $null

    switch -Wildcard ($PSCmdlet.ParameterSetName) {
        'Id-*' {
            $HostId = $Id
        }
        'Name-*' {
            $HostLookupResult = (Get-LMDevice -Name $Name).Id
            if (Test-LookupResult -Result $HostLookupResult -LookupString $Name) {
                return
            }
            $HostId = $HostLookupResult
        }
        'DisplayName-*' {
            $HostLookupResult = (Get-LMDevice -DisplayName $DisplayName).Id
            if (Test-LookupResult -Result $HostLookupResult -LookupString $DisplayName) {
                return
            }
            $HostId = $HostLookupResult
        }
    }

    if ($PSCmdlet.ParameterSetName -like '*-diagnosticId') {
        $ResolvedDiagnosticId = $DiagnosticId
    }
    else {
        $DiagnosticLookupResult = (Get-LMDiagnosticSource -Name $DiagnosticName).Id
        if (Test-LookupResult -Result $DiagnosticLookupResult -LookupString $DiagnosticName) {
            return
        }
        $ResolvedDiagnosticId = $DiagnosticLookupResult
    }

    $ResourcePath = "/setting/diagnosticsources/executemanually"
    $Data = @{
        diagnosticId = $ResolvedDiagnosticId
        hostId       = $HostId
        alertId      = $AlertId
    }
    $Body = Format-LMData -Data $Data -UserSpecifiedKeys $PSBoundParameters.Keys

    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Body
    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

    return (Add-ObjectTypeInfo -InputObject $Response -TypeName 'LogicMonitor.DiagnosticSourceExecution')
}
