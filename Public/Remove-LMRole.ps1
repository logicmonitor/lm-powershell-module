<#
.SYNOPSIS
Removes a LogicMonitor role.

.DESCRIPTION
The Remove-LMRole function removes a LogicMonitor role based on the specified Id or Name. It requires a valid API authentication and authorization.

.PARAMETER Id
The Id of the role to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The Name of the role to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMRole -Id 123
Removes the LogicMonitor role with the Id 123.

.EXAMPLE
Remove-LMRole -Name "Admin"
Removes the LogicMonitor role with the Name "Admin".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed role and a success message confirming the removal.

.NOTES
This function requires a valid API authentication and authorization. Use Connect-LMAccount to log in before running this command.
#>
function Remove-LMRole {

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
                $LookupResult = (Get-LMRole -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/roles/$Id"

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
                if ($PSCmdlet.ShouldProcess($Message, "Remove User Role")) {
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                    #Issue request
                    Invoke-LMRestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1] | Out-Null

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
