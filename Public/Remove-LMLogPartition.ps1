<#
.SYNOPSIS
Removes a LogicMonitor log partition.

.DESCRIPTION
The Remove-LMLogPartition function removes a LogicMonitor log partition based on the specified Id or Name. It requires a valid API authentication and authorization.

.PARAMETER Id
The Id of the log partition to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The Name of the log partition to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMLogPartition -Id 123
Removes the LogicMonitor log partition with the Id 123.

.EXAMPLE
Remove-LMLogPartition -Name "customerA"
Removes the LogicMonitor log partition with the Name "customerA".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed log partition and a success message confirming the removal.

.NOTES
This function requires a valid API authentication and authorization. Use Connect-LMAccount to log in before running this command.
#>
function Remove-LMLogPartition {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
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

            #Loop through requests
            try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove Log Partition")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -CallerPSCmdlet $PSCmdlet -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

                    $Result = [PSCustomObject]@{
                        Id      = $Id
                        Message = "Successfully removed ($Message)"
                    }

                    return $Result
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
