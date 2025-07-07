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

function Set-LMLogPartition {

    [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$Description,

        [Nullable[int]]$Retention,

        [ValidateSet("LG3", "LGE", "LG7", "LG90", "IP3", "IPC", "IP7", "IP90")]
        [String]$Sku,

        [ValidateSet("active", "inactive")]
        [String]$Status

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
            $ResourcePath = "/log/partitions/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            try {
                $Data = @{
                    description = $Description
                    retention   = $Retention
                    sku         = $Sku
                    active      = if ($Status -eq "active") { $true } elseif ($Status -eq "inactive") { $false } else { $null }
                }

                #Remove empty keys so we dont overwrite them
                $Data = Format-LMData `
                    -Data $Data `
                    -UserSpecifiedKeys $MyInvocation.BoundParameters.Keys

                if ($PSCmdlet.ShouldProcess($Message, "Set Log Partition")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
