<#
.SYNOPSIS
Updates a LogicMonitor Log Partition configuration to either pause or resume log ingestion.

.DESCRIPTION
The Set-LMLogPartitionAction function modifies an existing log partition action in LogicMonitor.

.PARAMETER Id
Specifies the ID of the log partition action to modify.

.PARAMETER Name
Specifies the current name of the log partition to modify.

.PARAMETER Action
Specifies the new action for the log partition. Possible values are "pause" or "resume".

.EXAMPLE
Set-LMLogPartitionAction -Id 123 -Action "pause"
Updates the log partition with ID 123 to pause log ingestion.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.LogPartition object containing the updated log partition information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMLogPartitionAction {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [ValidateSet("pause", "resume")]
        [String]$Action

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            #Lookup Log Partition Id
            if ($Name) {
                $LookupResult = (Get-LMLogPartition -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/log/partitions/$Id/$Action"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name) | Action: $Action"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name | Action: $Action"
            }
            else {
                $Message = "Id: $Id | Action: $Action"
            }

            try {

                if ($PSCmdlet.ShouldProcess($Message, "Set Log Partition Action")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    $Response = Invoke-LMRestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]

                    return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogPartition" )
                }
            }
            catch {
                return
            }
        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
