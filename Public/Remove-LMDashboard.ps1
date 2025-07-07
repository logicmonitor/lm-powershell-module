<#
.SYNOPSIS
Removes a LogicMonitor dashboard.

.DESCRIPTION
The Remove-LMDashboard function is used to remove a LogicMonitor dashboard. It supports removing a dashboard by either its ID or name.

.PARAMETER Id
Specifies the ID of the dashboard to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the dashboard to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMDashboard -Id 123
Removes the dashboard with ID 123.

.EXAMPLE
Remove-LMDashboard -Name "My Dashboard"
Removes the dashboard with the name "My Dashboard".

.INPUTS
You can pipe input to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed dashboard and a message indicating the success of the removal operation.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running this command.
#>
function Remove-LMDashboard {

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
                $LookupResult = (Get-LMDashboard -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/dashboard/dashboards/$Id"

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
                if ($PSCmdlet.ShouldProcess($Message, "Remove Dashboard")) {
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
