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

.EXAMPLE
#Create a new log partition
New-LMLogPartition -Name "customerA" -Description "Customer A Log Partition" -Retention 30 -Status "active" -Tenant "customerA"

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogPartition object.
#>

Function New-LMLogPartition {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,
        [Parameter(Mandatory)]
        [String]$Description,
        [Parameter(Mandatory)]
        [Int]$Retention,
        [Parameter(Mandatory)]
        [ValidateSet("active", "inactive")]
        [String]$Status,
        [Parameter(Mandatory)]
        [String]$Tenant,
        [ValidateSet("LG3", "LGE", "LG7","LG90","IP3","IPC","IP7","IP90")]
        [String]$Sku
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/log/partitions"

        If (!$Sku) {
            #Get the sku from the default log partition if not specified
            $Sku = (Get-LMLogPartition -Name "default").sku
        }

        Try {
            $Data = @{
                name        = $Name
                description = $Description
                retention   = $Retention
                active      = $(If ($Status -eq "active") { $true }Else { $false })
                tenant      = $Tenant
                sku         = $Sku
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $Params

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
