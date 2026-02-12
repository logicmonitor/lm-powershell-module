<#
.SYNOPSIS
Triggers a remediation source execution for a host.

.DESCRIPTION
The Invoke-LMRemediationSource function manually triggers a remediation source execution for a
LogicMonitor host. The host can be identified by ID, name, or display name, and the remediation
source can be identified by ID or name.

.PARAMETER Id
The host ID to run the remediation source against. Alias: HostId.

.PARAMETER Name
The host name to run the remediation source against. Alias: HostName.

.PARAMETER DisplayName
The host display name to run the remediation source against.

.PARAMETER RemediationId
The remediation source ID to execute.

.PARAMETER RemediationName
The remediation source name to execute.

.PARAMETER AlertId
Optional alert ID associated with this remediation execution.

.EXAMPLE
Invoke-LMRemediationSource -Id 123 -RemediationId 456

Triggers remediation source ID 456 on host ID 123.

.EXAMPLE
Invoke-LMRemediationSource -HostName "server01" -RemediationName "Restart Agent" -AlertId "A123456"

Looks up host and remediation source by name, then triggers a remediation execution associated with alert A123456.

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.RemediationSourceExecution object.
#>
function Invoke-LMRemediationSource {

    [CmdletBinding(DefaultParameterSetName = 'Id-remediationId')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id-remediationId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-remediationName', ValueFromPipelineByPropertyName)]
        [Alias('HostId', 'DeviceId')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-remediationId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-remediationName')]
        [Alias('HostName', 'DeviceName')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'DisplayName-remediationId')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-remediationName')]
        [Alias('HostDisplayName', 'DeviceDisplayName')]
        [String]$DisplayName,

        [Parameter(Mandatory, ParameterSetName = 'Id-remediationId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-remediationId')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-remediationId')]
        [Int]$RemediationId,

        [Parameter(Mandatory, ParameterSetName = 'Id-remediationName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-remediationName')]
        [Parameter(Mandatory, ParameterSetName = 'DisplayName-remediationName')]
        [String]$RemediationName,

        [String]$AlertId
    )

    if (-not $Script:LMAuth.Valid) {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        return
    }

    $HostId = $null
    $ResolvedRemediationId = $null

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

    if ($PSCmdlet.ParameterSetName -like '*-remediationId') {
        $ResolvedRemediationId = $RemediationId
    }
    else {
        $RemediationLookupResult = (Get-LMRemediationSource -Name $RemediationName).Id
        if (Test-LookupResult -Result $RemediationLookupResult -LookupString $RemediationName) {
            return
        }
        $ResolvedRemediationId = $RemediationLookupResult
    }

    $ResourcePath = "/setting/remediationsources/executemanually"
    $Data = @{
        remediationId = $ResolvedRemediationId
        hostId        = $HostId
        alertId       = $AlertId
    }
    $Body = Format-LMData -Data $Data -UserSpecifiedKeys $PSBoundParameters.Keys

    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Body
    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Body

    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Body

    return (Add-ObjectTypeInfo -InputObject $Response -TypeName 'LogicMonitor.RemediationSourceExecution')
}
