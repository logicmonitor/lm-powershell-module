<#
.SYNOPSIS
Updates a LogicMonitor Log Partition configuration.

.DESCRIPTION
The Set-LMLogPartition function modifies an existing log partition in LogicMonitor.

.PARAMETER Id
Specifies the ID of the log partition to modify.

.PARAMETER Name
Specifies the current name of the log partition.

.PARAMETER Description
Specifies the new description for the log partition.

.PARAMETER Retention
Specifies the new retention for the log partition.

.PARAMETER Sku
Specifies the new sku for the log partition.

.PARAMETER Status
Specifies the new status for the log partition. Possible values are "active" or "inactive".

.EXAMPLE
Set-LMLogPartition -Id 123 -Description "New description" -Retention 30 -Status "active"
Updates the log partition with ID 123 with a new description, retention, and status.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.LogPartition object containing the updated log partition information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

Function Set-LMLogPartition {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    Param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$Description,

        [Nullable[int]]$Retention,

        [ValidateSet("LG3", "LGE", "LG7","LG90","IP3","IPC","IP7","IP90")]
        [String]$Sku,

        [ValidateSet("active", "inactive")]
        [String]$Status

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
            $ResourcePath = "/log/partitions/$Id"

            If ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else {
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    description = $Description
                    retention   = $Retention
                    sku         = $Sku
                    active      = If ($Status -eq "active") { $true } ElseIf ($Status -eq "inactive") { $false } Else { $null }
                }
            
                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

                If ($PSCmdlet.ShouldProcess($Message, "Set Log Partition")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogPartition" )
                }
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
