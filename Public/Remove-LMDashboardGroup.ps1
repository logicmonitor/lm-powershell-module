<#
.SYNOPSIS
Removes a LogicMonitor dashboard group.

.DESCRIPTION
The Remove-LMDashboardGroup function removes a LogicMonitor dashboard group based on the specified Id or Name.

.PARAMETER Id
The Id of the dashboard group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the dashboard group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMDashboardGroup -Id 123
Removes the dashboard group with Id 123.

.EXAMPLE
Remove-LMDashboardGroup -Name "MyDashboardGroup"
Removes the dashboard group with the name "MyDashboardGroup".

.INPUTS
None.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed dashboard group and a success message confirming the removal.

.NOTES
This function requires a valid LogicMonitor API authentication.
#>
function Remove-LMDashboardGroup {

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

            #Lookup Id if supplying dashboard name
            if ($Name) {
                $LookupResult = (Get-LMDashboardGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/dashboard/groups/$Id"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Dashboard Group")) {
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
