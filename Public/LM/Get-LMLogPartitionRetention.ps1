<#
.SYNOPSIS
Retrieves LM Log Partition Retentions from LogicMonitor.

.DESCRIPTION
The Get-LMLogPartitionRetention function retrieves LM Log Partition Retentions from LogicMonitor. It can retrieve all log partition retentions available to the account.

.EXAMPLE
#Retrieve all log partition retentions
Get-LMLogPartitionRetention

.NOTES
You must run Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns LogicMonitor.LogPartitionRetention objects.
#>

function Get-LMLogPartitionRetention {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    param (
        [ValidateRange(1, 1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    if ($Script:LMAuth.Valid) {

        #Build header and uri
        $ResourcePath = "/log/partitions/retentions"

        $CommandInvocation = $MyInvocation
        $CallerPSCmdlet = $PSCmdlet

        $Results = Invoke-LMPaginatedGet -BatchSize $BatchSize -InvokeRequest {
            param($Offset, $PageSize)

            $RequestResourcePath = $ResourcePath
            $QueryParams = "?size=$PageSize&offset=$Offset&sort=+id"

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $RequestResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $RequestResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $CommandInvocation

            $Response = Invoke-LMRestMethod -CallerPSCmdlet $CallerPSCmdlet -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
            if ($null -eq $Response) {
                return $null
            }

            return $Response
        }

        if ($null -eq $Results) {
            return
        }

        return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.LogPartitionRetention" )
    }
    else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
