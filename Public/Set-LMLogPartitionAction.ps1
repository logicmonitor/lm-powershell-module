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

Function Set-LMLogPartitionAction {

    [CmdletBinding()]
    Param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [ValidateSet("pause", "resume")]
        [String]$Action

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            #Lookup Log Partition Id
            If ($Name) {
                $LookupResult = (Get-LMLogPartition -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
                    
            #Build header and uri
            $ResourcePath = "/log/partitions/$Id/$Action"

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogPartition" )
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
