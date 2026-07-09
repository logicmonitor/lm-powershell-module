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

.PARAMETER ContractIntervalHours
The contract interval in hours. 0 = monthly (1st of next month), 24 = daily, 168 = weekly (next Monday), or a custom hour value.

.PARAMETER AutoRestartOnRenewal
When true, ingestion automatically restarts on contract renewal.

.PARAMETER UsageLimit
The usage limit for the log partition contract, for example 100GB. Use with the UsageLimit parameter set together with StopIngestionOnLimit.

.PARAMETER StopIngestionOnLimit
When true, ingestion stops when the usage limit is exceeded. Use with the UsageLimit parameter set together with UsageLimit.

.EXAMPLE
Set-LMLogPartition -Id 123 -Description "New description" -Retention 30 -Status "active"
Updates the log partition with ID 123 with a new description, retention, and status.

.EXAMPLE
Set-LMLogPartition -Id 123 -UsageLimit "100GB" -StopIngestionOnLimit $true -AutoRestartOnRenewal $true
Updates usage limit controls for the log partition with ID 123.

.INPUTS
None.

.OUTPUTS
Returns a LogicMonitor.LogPartition object containing the updated log partition information.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>

function Set-LMLogPartition {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'IdUsageLimit', Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name', Mandatory)]
        [Parameter(ParameterSetName = 'NameUsageLimit', Mandatory)]
        [String]$Name,

        [String]$Description,

        [Nullable[int]]$Retention,

        [ValidateSet("LG3", "LGE", "LG7", "LG90", "IP3", "IPC", "IP7", "IP90")]
        [String]$Sku,

        [ValidateSet("active", "inactive")]
        [String]$Status,

        [Int]$ContractIntervalHours,

        [bool]$AutoRestartOnRenewal,

        [Parameter(ParameterSetName = 'IdUsageLimit', Mandatory)]
        [Parameter(ParameterSetName = 'NameUsageLimit', Mandatory)]
        [String]$UsageLimit,

        [Parameter(ParameterSetName = 'IdUsageLimit', Mandatory)]
        [Parameter(ParameterSetName = 'NameUsageLimit', Mandatory)]
        [bool]$StopIngestionOnLimit

    )
    #Check if we are logged in and have valid api creds
    begin {}
    process {
        if ($Script:LMAuth.Valid) {
            $ExistingPartition = $null

            #Lookup Log Partition Id
            if ($PSItem -and $PSItem.activeContract) {
                $ExistingPartition = $PSItem
                if (-not $Id -and $PSItem.Id) {
                    $Id = $PSItem.Id
                }
            }
            elseif ($Name) {
                $ExistingPartition = Get-LMLogPartition -Name $Name
                $LookupResult = $ExistingPartition.Id
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

            $Data = @{
                description = $Description
                active      = if ($Status -eq "active") { $true } elseif ($Status -eq "inactive") { $false } else { $null }
            }

            $activeContract = Build-LMLogPartitionActiveContract `
                -BoundParameters $PSBoundParameters `
                -Values @{
                    Retention             = $Retention
                    Sku                   = $Sku
                    ContractIntervalHours = $ContractIntervalHours
                    UsageLimit            = $UsageLimit
                    AutoRestartOnRenewal  = $AutoRestartOnRenewal
                    StopIngestionOnLimit  = $StopIngestionOnLimit
                }

            if ($activeContract.Count -gt 0) {
                if ($null -eq $ExistingPartition) {
                    $ExistingPartition = Get-LMLogPartition -Id $Id
                }

                $Data.activeContract = Merge-LMLogPartitionActiveContract `
                    -ExistingContract $ExistingPartition.activeContract `
                    -Patch $activeContract
            }

            #Remove empty keys so we dont overwrite them
            $Data = Format-LMData `
                -Data $Data `
                -UserSpecifiedKeys $PSBoundParameters.Keys

            if ($PSCmdlet.ShouldProcess($Message, "Set Log Partition")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogPartition" )
            }

        }
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
