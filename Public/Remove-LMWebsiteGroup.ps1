<#
.SYNOPSIS
Removes a website group from LogicMonitor.

.DESCRIPTION
The Remove-LMWebsiteGroup function removes a website group from LogicMonitor using either its ID or name.

.PARAMETER Id
Specifies the ID of the website group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the website group to remove. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER DeleteHostsandChildren
Specifies whether to delete the hosts and their children within the website group. Default value is $false.

.EXAMPLE
Remove-LMWebsiteGroup -Id 123
Removes the website group with ID 123.

.EXAMPLE
Remove-LMWebsiteGroup -Name "MyGroup" -DeleteHostsandChildren $true
Removes the website group named "MyGroup" and all its child items.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
Returns a PSCustomObject containing the ID of the removed website group and a success message confirming the removal.
#>

function Remove-LMWebsiteGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id', SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Boolean]$DeleteHostsandChildren = $false

    )
    begin {}
    process {
        #Check if we are logged in and have valid api creds
        if ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            if ($Name) {
                $LookupResult = (Get-LMWebsiteGroup -Name $Name).Id
                if (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Translate RecursiveDelete
            $deleteChildren = if ($DeleteHostsandChildren) { 2 }else { 1 }

            #Build header and uri
            $ResourcePath = "/website/groups/$Id"
            $QueryParams = "?deleteChildren=$deleteChildren"

            if ($PSItem) {
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            elseif ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            else {
                $Message = "Id: $Id"
            }

            
            if ($PSCmdlet.ShouldProcess($Message, "Remove Website Group")) {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).$(Get-LMPortalURI)" + $ResourcePath + $QueryParams

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
