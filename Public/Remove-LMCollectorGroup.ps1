<#
.SYNOPSIS
Removes a LogicMonitor Collector Group.

.DESCRIPTION
The Remove-LMCollectorGroup function removes a LogicMonitor Collector Group based on the provided Id or Name.

.PARAMETER Id
Specifies the Id of the Collector Group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the Collector Group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMCollectorGroup -Id 123
Removes the Collector Group with Id 123.

.EXAMPLE
Remove-LMCollectorGroup -Name "Group1"
Removes the Collector Group with Name "Group1".

.NOTES
This function requires valid API credentials to be logged in. Use Connect-LMAccount to log in before running this command.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed collector group and a success message confirming the removal.
#>
function Remove-LMCollectorGroup {

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
                $LookupResult = (Get-LMCollectorGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($PSItem) {
                $Message = "Id: $($PSItem.id) | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            #Build header and uri
            $ResourcePath = "/setting/collector/groups/$Id"

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Collector Group")) {
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
        else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    end {}
}
