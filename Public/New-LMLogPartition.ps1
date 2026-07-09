<#
.SYNOPSIS
Creates a new LogicMonitor Log Partition.

.DESCRIPTION
The New-LMLogPartition function creates a new LogicMonitor Log Partition.

.PARAMETER Name
The name of the new log partition.

.PARAMETER Description
The description of the new log partition.

.PARAMETER Retention
The retention in days of the new log partition.

.PARAMETER Status
The status of the new log partition. Possible values are "active" or "inactive".

.PARAMETER Sku
The sku of the new log partition. If not specified, the sku from the default log partition will be used. Its recommended to not specify this parameter and let the function determine the sku.

.PARAMETER Tenant
The tenant of the new log partition.

.PARAMETER ContractIntervalHours
The contract interval in hours. 0 = monthly (1st of next month), 24 = daily, 168 = weekly (next Monday), or a custom hour value.

.PARAMETER AutoRestartOnRenewal
When true, ingestion automatically restarts on contract renewal.

.PARAMETER UsageLimit
The usage limit for the log partition contract, for example 100GB. Use with the UsageLimit parameter set together with StopIngestionOnLimit.

.PARAMETER StopIngestionOnLimit
When true, ingestion stops when the usage limit is exceeded. Use with the UsageLimit parameter set together with UsageLimit.

.EXAMPLE
#Create a new log partition
New-LMLogPartition -Name "customerA" -Description "Customer A Log Partition" -Retention 30 -Status "active" -Tenant "customerA"

.EXAMPLE
#Create a new log partition with usage limit controls
New-LMLogPartition -Name "customerA" -Description "Customer A Log Partition" -Retention 30 -Status "active" -Tenant "customerA" -UsageLimit "100GB" -StopIngestionOnLimit $true -AutoRestartOnRenewal $true

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogPartition object.
#>

function New-LMLogPartition {

    [CmdletBinding(DefaultParameterSetName = 'Standard', SupportsShouldProcess, ConfirmImpact = 'None')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [String]$Description,

        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [Int]$Retention,

        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [ValidateSet("active", "inactive")]
        [String]$Status,

        [Parameter(Mandatory, ParameterSetName = 'Standard')]
        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [String]$Tenant,

        [Parameter(ParameterSetName = 'Standard')]
        [Parameter(ParameterSetName = 'UsageLimit')]
        [ValidateSet("LG3", "LGE", "LG7", "LG90", "IP3", "IPC", "IP7", "IP90")]
        [String]$Sku,

        [Parameter(ParameterSetName = 'Standard')]
        [Parameter(ParameterSetName = 'UsageLimit')]
        [Int]$ContractIntervalHours,

        [Parameter(ParameterSetName = 'Standard')]
        [Parameter(ParameterSetName = 'UsageLimit')]
        [bool]$AutoRestartOnRenewal,

        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [String]$UsageLimit,

        [Parameter(Mandatory, ParameterSetName = 'UsageLimit')]
        [bool]$StopIngestionOnLimit
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/log/partitions"

        if (!$Sku) {
            #Get the sku from the default log partition if not specified
            $Sku = (Get-LMLogPartition -Name "default").activeContract.sku
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
            } `
            -AlwaysInclude @('Retention', 'Sku')

        $Data = @{
            name           = $Name
            description    = $Description
            active         = $(if ($Status -eq "active") { $true } else { $false })
            tenant         = $Tenant
            activeContract = $activeContract
        }

        $Data = ($Data | ConvertTo-Json -Depth 5)

        $Message = "Name: $Name | Tenant: $Tenant"

        if ($PSCmdlet.ShouldProcess($Message, "Create Log Partition")) {
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.LogPartition" )

        }
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
