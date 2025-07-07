<#
.SYNOPSIS
Removes a LogicMonitor access group.

.DESCRIPTION
The Remove-LMAccessGroup function removes a LogicMonitor access group based on the specified ID or name.

.PARAMETER Id
The ID of the access group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the access group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMAccessGroup -Id 123
Removes the access group with the ID 123.

.EXAMPLE
Remove-LMAccessGroup -Name "MyAccessGroup"
Removes the access group with the name "MyAccessGroup".

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using Connect-LMAccount before running this command.

.INPUTS
None. You cannot pipe objects to this command.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed access group and a success message confirming the removal.
#>
function Remove-LMAccessGroup {

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
                $LookupResult = (Get-LMAccessGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            #Build header and uri
            $ResourcePath = "/setting/accessgroup/$Id"

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove AccessGroup")) {
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
